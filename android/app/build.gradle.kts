plugins {
    id("com.android.application")
    id("com.google.gms.google-services") // ✅ REQUIRED
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.smart_expense_tracker"

    // 🔥 REQUIRED for Google Sign-In, Path Provider, Firebase
    compileSdk = 36

    defaultConfig {
        applicationId = "com.example.smart_expense_tracker"
        minSdk = flutter.minSdkVersion
        targetSdk = 36
        versionCode = 1
        versionName = "1.0"
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

dependencies {
    // 🔥 Firebase BOM
    implementation(platform("com.google.firebase:firebase-bom:33.5.1"))

    implementation("com.google.firebase:firebase-auth")
    implementation("com.google.firebase:firebase-firestore")
    implementation("com.google.firebase:firebase-messaging")

    // 🔧 Required for Java 17
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
}
