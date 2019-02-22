#Ordnance Survey Android Code Style Guidelines

The aim of this document is to ensure a consistent style guide across our code base, to better promote readability and make it easier to spot potential problems within the code base. 
These guidelines were agreed by the team, and based off of the [Android Code Style Guidelines for Contributors](https://source.android.com/source/code-style.html)

##1. Gradle
All Android projects (including Java libraries developed for use with Android) are to be built using Gradle and structured as per the defaults for those project types. This is to ensure that all builds are prepared, tested and deployed with a consistent set of methods and plugins.
Where appropriate repeated build logic will be moved into Gradle plugins for use within OS projects.

Android Studio will create a Gradle structured project by default. 

For developers moving from and Maven or Ant based build the following documentation from Gradle will help the transition:

[Gradle - Getting Started Android](https://gradle.org/getting-started-android/)

##2. Consistent Code Base

There are a range of checks made against OS Android projects using the base Gradle Quality checks configured for usage with the Android Gradle Plugin.

These are:
- Checkstyle
- Findbugs
- PMD
- Android Lint
- Unit Testing
- Jacoco Unit Test Coverage
- AndroidTest
- AndroidTest Coverage

To aid the configuration and usage of these checks an android gradle plugin has been developed.

[Gradle Plugin - Android Checks](https://github.com/OrdnanceSurvey/gradle-plugin-android-checks)

The information on how to implement and configure this plugin are contained in the plugin README.

All Android projects (including Java libraries developed for use with Android) will use this plugin to ensure consistency of checks across projects.

As part of the configuration of the plugin any rule-sets used should be drawn from the guidelines described here.

### Rules / Exceptions

- [Checkstyle Rules](https://github.com/OrdnanceSurvey/code-style-guide/tree/master/Android/checkstyle)
- [PMD Rules](https://github.com/OrdnanceSurvey/code-style-guide/tree/master/Android/pmd)

### Intellij and Android Studio
For these two IDE's there are some shortcuts to help with fixing issues with checkstyle. The following two commands when applied to any .java and Android xml file will eliminate the majority of checkstyle issues:

Optimise Imports:

Mac - 

    ctrl + alt + O

Windows -

    Ctrl + Alt + O

Optimise Code:

Mac -
    
    alt + cmd + L

Windows -

    Ctrl + Alt + L
    
For more keyboard shortcuts for these IDE's choose Help | Default Keymap Reference from the main menu.
