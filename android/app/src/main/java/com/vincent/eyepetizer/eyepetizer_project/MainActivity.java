package com.vincent.eyepetizer.eyepetizer_project;

import android.os.Bundle;

import androidx.annotation.Nullable;

import io.flutter.embedding.android.FlutterActivity;
import org.devio.flutter.splashscreen.SplashScreen;

public class MainActivity extends FlutterActivity {

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        SplashScreen.show(this, true);
        super.onCreate(savedInstanceState);
    }
}
