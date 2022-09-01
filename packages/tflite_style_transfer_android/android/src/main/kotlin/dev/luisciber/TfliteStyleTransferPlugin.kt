package dev.luisciber

import android.content.Context
import android.content.res.AssetFileDescriptor
import android.graphics.Bitmap
import android.net.Uri
import android.util.Log
import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.io.*
import java.lang.Exception
import java.util.*

class TfliteStyleTransferPlugin : FlutterPlugin, MethodCallHandler {
    private lateinit var channel: MethodChannel
    private lateinit var context: Context
    private var cpuStyleTransfer: StyleTransfer? = null
    private var gpuStyleTransfer: StyleTransfer? = null
    private lateinit var flutterAssets: FlutterPlugin.FlutterAssets

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(
            flutterPluginBinding.binaryMessenger,
            "tflite_style_transfer_android"
        )

        channel.setMethodCallHandler(this)

        context = flutterPluginBinding.applicationContext

        flutterAssets = flutterPluginBinding.flutterAssets

        try {
            cpuStyleTransfer = StyleTransfer.newCPUStyleTransfer(context)
        } catch (e: Exception) {
            Log.d(StyleTransfer.TAG, "Error cpuStyleTransfer")
        }

        try {
            gpuStyleTransfer = StyleTransfer.newGPUStyleTransfer(context)
        } catch (e: Exception) {
            Log.d(StyleTransfer.TAG, "Error gpuStyleTransfer")
        }
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "getPlatformName" -> result.success("Android")
            "runStyleTransfer" -> {
                Log.d("tflite_android", "Running style transfer")
                // get arguments
                val styleImagePath = call.argument<String>("styleImagePath")
                val imagePath = call.argument<String>("imagePath")
                val styleFromAssets = call.argument<Boolean>("styleFromAssets")

                if (styleImagePath != null && imagePath != null && styleFromAssets != null) {
                    val generatedImagePath = runStyleTransfer(
                        styleImagePath, imagePath, styleFromAssets
                    )

                    if (generatedImagePath != null) {
                        result.success(generatedImagePath)
                    } else {
                        result.error("-1", "StyleTransfer generation error", null)
                    }
                } else {
                    result.error(
                        "-1",
                        "Android could not extract flutter arguments in method: (runStyleTransfer)",
                        null
                    )
                }
            }
            else -> result.notImplemented()
        }
    }

    private fun runStyleTransfer(
        styleImage: String,
        imagePath: String,
        styleFromAssets: Boolean
    ): String? {
        val styleImagePath = if (styleFromAssets) {
            val flutterPath = flutterAssets.getAssetFilePathByName(styleImage)

            // TODO: I need get the path of the style image from assets but I don't know how to
            // In the meantime ->
            // Copy style image to temporal file.
            val inputStream = context.assets.open(flutterPath)

            val fileOutput = File.createTempFile(
                UUID.randomUUID().toString(), "jpg",
                context.cacheDir
            )

            val outputStream = FileOutputStream(fileOutput)

            copyFile(inputStream, outputStream)

            // And return the path of it file
            fileOutput.path
        } else {
            styleImage
        }


        val result = when {
            gpuStyleTransfer != null -> {
                gpuStyleTransfer!!.runStyleTransfer(imagePath, styleImagePath)
            }
            cpuStyleTransfer != null -> {
                cpuStyleTransfer!!.runStyleTransfer(imagePath, styleImagePath)
            }
            else -> {
                null
            }
        }

        return if (result != null) {
            val image = result.styledImage

            val fileOutput = File.createTempFile(
                UUID.randomUUID().toString(), "jpg",
                context.cacheDir
            )

            val outputStream = FileOutputStream(fileOutput)

            image.compress(Bitmap.CompressFormat.JPEG, 100, outputStream)

            return fileOutput.path
        } else {
            null
        }
    }

    private fun copyFile(input: InputStream, output: OutputStream) {
        val buffer = ByteArray(1024)
        var read: Int;

        do {
            read = input.read(buffer)

            if (read != -1)
                output.write(buffer, 0, read)
        } while (read != -1)
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        cpuStyleTransfer?.close()
        gpuStyleTransfer?.close()
        // context = null
    }
}