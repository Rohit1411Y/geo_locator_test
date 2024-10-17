package com.example.geo_locator_learning
import android.Manifest
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Bundle
import android.provider.Settings
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import com.google.android.gms.location.*
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import java.lang.Exception
import java.util.concurrent.TimeUnit

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.yourcompany.location"
    private val LOCATION_PERMISSION_REQUEST_CODE = 1001

    private lateinit var fusedLocationClient: FusedLocationProviderClient
    private var pendingResult: MethodChannel.Result? = null

    override fun configureFlutterEngine(flutterEngine: io.flutter.embedding.engine.FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        fusedLocationClient = LocationServices.getFusedLocationProviderClient(this)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when(call.method) {
                "getCurrentLocation" -> {
                    if (checkPermissions()) {
                        getLocation(result)
                    } else {
                        pendingResult = result
                        requestPermissions()
                    }
                }
                "openAppSettings" -> {
                    openAppSettings()
                    result.success(null)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    private fun checkPermissions(): Boolean {
        val fineLocation = ContextCompat.checkSelfPermission(this, Manifest.permission.ACCESS_FINE_LOCATION)
        val coarseLocation = ContextCompat.checkSelfPermission(this, Manifest.permission.ACCESS_COARSE_LOCATION)
        return fineLocation == PackageManager.PERMISSION_GRANTED ||
                coarseLocation == PackageManager.PERMISSION_GRANTED
    }

    private fun requestPermissions() {
        ActivityCompat.requestPermissions(
            this,
            arrayOf(Manifest.permission.ACCESS_FINE_LOCATION, Manifest.permission.ACCESS_COARSE_LOCATION),
            LOCATION_PERMISSION_REQUEST_CODE
        )
    }

    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<String>, grantResults: IntArray) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode == LOCATION_PERMISSION_REQUEST_CODE) {
       val fineGranted = grantResults.isNotEmpty() && grantResults[0] == PackageManager.PERMISSION_GRANTED
        val coarseGranted = grantResults.size > 1 && grantResults[1] == PackageManager.PERMISSION_GRANTED
            if (fineGranted||coarseGranted) {
                // Permissions granted, proceed to fetch location
                getLocation(pendingResult)
            } else {
                // Permissions denied
                pendingResult?.error("PERMISSION_DENIED", "Location permissions are denied", null)
            }
            pendingResult = null
        }
    }

    private fun getLocation(result: MethodChannel.Result?) {
        try {
            val locationRequest = LocationRequest.Builder(
                Priority.PRIORITY_BALANCED_POWER_ACCURACY,
                0L // Interval in milliseconds
            ).setMinUpdateIntervalMillis(0L)
             .setMaxUpdateDelayMillis(0L)
             .setMaxUpdates(1)
             .build()

            fusedLocationClient.requestLocationUpdates(locationRequest, object : LocationCallback() {
                override fun onLocationResult(locationResult: LocationResult) {
                    fusedLocationClient.removeLocationUpdates(this)
                    if (locationResult.locations.isEmpty()) {
                        result?.error("UNAVAILABLE", "Location not available", null)
                        return
                    }
                    val location = locationResult.locations[0]
                    val locationMap = mapOf(
                        "latitude" to location.latitude,
                        "longitude" to location.longitude
                    )
                    result?.success(locationMap)
                }

                override fun onLocationAvailability(locationAvailability: LocationAvailability) {
                    super.onLocationAvailability(locationAvailability)
                    if (!locationAvailability.isLocationAvailable) {
                        result?.error("UNAVAILABLE", "Location is not available", null)
                    }
                }
            }, mainLooper)
        } catch (e: Exception) {
            result?.error("ERROR", e.localizedMessage, null)
        }
    }

    private fun openAppSettings() {
        val intent = Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS)
        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        intent.data = android.net.Uri.fromParts("package", packageName, null)
        startActivity(intent)
    }
}
