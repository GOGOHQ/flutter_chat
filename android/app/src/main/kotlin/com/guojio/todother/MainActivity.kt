package com.guojio.todother


import android.media.MediaMetadataRetriever
import android.os.Bundle
import com.arthenica.mobileffmpeg.FFmpeg
import com.arthenica.mobileffmpeg.FFmpeg.RETURN_CODE_SUCCESS
import io.flutter.plugins.GeneratedPluginRegistrant
import kotlin.math.ceil
import androidx.annotation.NonNull
import io.flutter.plugin.common.*
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine



class MainActivity : FlutterActivity() {

    private val CHANNELFFMPEG = "com.guojio.todother/nativeFunc";
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

    }


    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNELFFMPEG).setMethodCallHandler { call, result ->

            when (call.method) {
                "runFfmpeg" -> {
                    val cmd: String = call.argument<String>("cmd")!!
                    runFfmpeg(cmd, result)
                }
                "getMediaDuration" -> {
                    val filePath: String = call.argument<String>("filePath")!!
                    getMediaDuration(filePath, result)
                }


                else -> result.notImplemented()
            }
        }
    }



    private fun runFfmpeg(cmd: String, result: MethodChannel.Result) {
        FFmpeg.execute(cmd)
        val rc: Int = FFmpeg.getLastReturnCode()
        if (rc == RETURN_CODE_SUCCESS) {
            result.success(mapOf(
                    "result" to "OK"
            ))
        } else {
            result.error("failed", FFmpeg.getLastCommandOutput(), null)
        }
    }

    private fun getMediaDuration(filePath: String, result: MethodChannel.Result) {
        val media: MediaMetadataRetriever = MediaMetadataRetriever()
        media.setDataSource(filePath)
        val duration: Int = ceil(media.extractMetadata(MediaMetadataRetriever.METADATA_KEY_DURATION).toDouble() / 1000).toInt()
        result.success(mapOf(
                "duration" to duration,
                "result" to "OK"
        ))
    }

}