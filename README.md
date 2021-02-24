# fluttervote

Flutter와 Firebase의 database를 연동하는 예제

Firebase 에서 프로젝트를 생성한 뒤,

IOS의 경우,

1. Bundle ID 를 등록한 뒤, GoogleService-Info.plist를 받아 Runner의 subfolder에 포함시켜 주는 작업


안드로이드의 경우, 

1. 파이어베이스 프로젝트에 Android package name을 설정
2. Firebase console에서 진행하다 다운받을 수 있는 google-services.json 파일을 android/app 디렉토리에 추가
3. android/app/build.gradle 에서 apply plugin: 'com.google.gms.google-services' 를 추가
4. android/build.gradle 에서 buildscript 의 dependencies 에  classpath 'com.google.gms:google-services:4.3.3' 를 추가

의 추가 작업이 필요합니다.
