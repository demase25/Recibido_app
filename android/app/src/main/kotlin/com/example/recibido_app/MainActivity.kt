package com.maxiserrano.recibido

import android.content.Intent
import android.net.Uri
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.maxiserrano.recibido/shared_files"
    private var sharedFiles: List<String>? = null

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
