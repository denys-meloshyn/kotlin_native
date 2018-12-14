package com.example.denysmeloshyn.kotlin_common

import android.os.Bundle
import android.support.v7.app.AppCompatActivity
import org.kotlin.mpp.mobile.createApplicationScreenMessage

class MainActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        createApplicationScreenMessage()

        setContentView(R.layout.activity_main)
    }
}
