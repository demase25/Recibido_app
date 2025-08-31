package com.maxiserrano.recibido

import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.view.WindowInsetsController
import androidx.core.view.WindowCompat
import androidx.core.view.WindowInsetsCompat
import androidx.core.view.WindowInsetsControllerCompat
import androidx.core.graphics.ColorUtils
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.maxiserrano.recibido/shared_files"
    private var sharedFiles: List<String>? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        
        // Configuración completa edge-to-edge para Android 15+ y SDK 35+
        setupEdgeToEdge()
    }
    
    private fun setupEdgeToEdge() {
        // Habilitar edge-to-edge
        WindowCompat.setDecorFitsSystemWindows(window, false)
        
        // Configurar colores del sistema usando las nuevas APIs
        val windowInsetsController = WindowCompat.getInsetsController(window, window.decorView)
        
        // Configurar colores de las barras del sistema (reemplazando APIs obsoletas)
        setupSystemBarColors(windowInsetsController)
        
        // Configurar comportamiento de los insets
        setupInsetsBehavior()
    }
    
    private fun setupSystemBarColors(windowInsetsController: WindowInsetsControllerCompat) {
        // Colores basados en la nueva paleta de la app (celeste pastel)
        val primaryColor = android.graphics.Color.parseColor("#A8D8EA") // celeste pastel principal
        val primaryDarkColor = android.graphics.Color.parseColor("#8BC4D9") // celeste pastel oscuro
        
        // Configurar barra de estado (reemplaza setStatusBarColor obsoleto)
        window.statusBarColor = android.graphics.Color.TRANSPARENT
        windowInsetsController.isAppearanceLightStatusBars = false // Iconos claros para fondo oscuro
        
        // Configurar barra de navegación (reemplaza setNavigationBarColor obsoleto)
        window.navigationBarColor = android.graphics.Color.TRANSPARENT
        windowInsetsController.isAppearanceLightNavigationBars = true // Iconos oscuros para fondo claro
        
        // Configurar divisor de navegación (reemplaza setNavigationBarDividerColor obsoleto)
        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.P) {
            window.navigationBarDividerColor = android.graphics.Color.TRANSPARENT
        }
    }
    
    private fun setupInsetsBehavior() {
        // Configurar comportamiento de los insets para edge-to-edge
        val decorView = window.decorView
        decorView.setOnApplyWindowInsetsListener { view, windowInsets ->
            val insets = WindowInsetsCompat.toWindowInsetsCompat(windowInsets)
            
            // Aplicar padding para evitar que el contenido se superponga con las barras del sistema
            val systemBars = insets.getInsets(WindowInsetsCompat.Type.systemBars())
            view.setPadding(systemBars.left, systemBars.top, systemBars.right, systemBars.bottom)
            
            windowInsets
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "getSharedFiles" -> {
                    result.success(sharedFiles)
                    sharedFiles = null // Limpiar después de enviar
                }
                else -> result.notImplemented()
            }
        }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        handleIntent(intent)
    }

    override fun onResume() {
        super.onResume()
        handleIntent(intent)
    }

    private fun handleIntent(intent: Intent) {
        val action = intent.action
        val type = intent.type

        if (Intent.ACTION_SEND == action && type != null) {
            val sharedFile = intent.getParcelableExtra<Uri>(Intent.EXTRA_STREAM)
            sharedFile?.let {
                val filePath = getFilePathFromUri(it)
                if (filePath != null) {
                    sharedFiles = listOf(filePath)
                }
            }
        } else if (Intent.ACTION_SEND_MULTIPLE == action && type != null) {
            val sharedFilesList = intent.getParcelableArrayListExtra<Uri>(Intent.EXTRA_STREAM)
            sharedFilesList?.let { uris ->
                val filePaths = uris.mapNotNull { getFilePathFromUri(it) }
                if (filePaths.isNotEmpty()) {
                    sharedFiles = filePaths
                }
            }
        }
    }

    private fun getFilePathFromUri(uri: Uri): String? {
        return try {
            val inputStream = contentResolver.openInputStream(uri)
            val fileName = getFileName(uri)
            val file = java.io.File(cacheDir, fileName)
            
            inputStream?.use { input ->
                file.outputStream().use { output ->
                    input.copyTo(output)
                }
            }
            
            file.absolutePath
        } catch (e: Exception) {
            e.printStackTrace()
            null
        }
    }

    private fun getFileName(uri: Uri): String {
        val cursor = contentResolver.query(uri, null, null, null, null)
        return cursor?.use {
            val nameIndex = it.getColumnIndex(android.provider.OpenableColumns.DISPLAY_NAME)
            it.moveToFirst()
            it.getString(nameIndex)
        } ?: "shared_file_${System.currentTimeMillis()}"
    }
}
