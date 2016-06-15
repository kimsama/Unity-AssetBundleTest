# 에셋 번들 병렬 빌드 

여기에서는 에셋 번들 빌드시 플랫폼을 스위칭하지 않고 빠르게 빌드할 수 있는 방법에 대해서 소개한다. 


AssetBundle 빌드
================

플롯폼 전환시 매우 많은 시간이 소요!

```csharp
// 개별 obj 마다 플랫폼 전환이 발생
foreach (  var  obj  in  objects  ) 
{ 
    //  Android 용 플랫폼 전환이 발생 
    BuildPipeline.BuildAssetBundle  ( obj ,  new  Object { obj }  
        string.Format ( " AB / {0} android .pack " ,  obj . name ) 
        BuildAssetBundleOptions.CollectDependencies ,  BuildTarget . Android ); 
    
    //  iOS 용으로 플랫폼 전환이 발생 
    BuildPipeline.BuildAssetBundle  ( obj ,  new  Object{ obj }  
        string.Format ( " AB / {0} iOS .pack " ,  obj . name ) 
        BuildAssetBundleOptions.CollectDependencies ,  BuildTarget . iPhone ); 
}
```
플랫폼별로 에셋번들을 빌드하는 쪽이 유리하다. 이 경우에도 플랫폼 전환시에는 전환에 따른 시간이 소요되긴 하지만 이전에 비해서는 빠르다.

```csharp
foreach (  var  obj  in  objects  ) 
{ 
    BuildPipeline.BuildAssetBundle  ( obj ,  new  Object { obj }  
        string.Format ( " AB / {0} android .pack " ,  obj . name )
        BuildAssetBundleOptions.CollectDependencies ,  BuildTarget . Android ); 
} 

// Android 플랫폼으로 번들 빌드후 iOS 플랫폼 전환

foreach (  var  obj  in  objects  ) 
{ 
    BuildPipeline.BuildAssetBundle  ( obj ,  new  Object{ obj }  
        string.Format ( " AB / {0} iOS .pack " ,  obj . name ) 
        BuildAssetBundleOptions.CollectDependencies ,  BuildTarget . iPhone ); 
}
```

프로젝트의 크기가 큰 경우, 바꾸어 이야기하면 프로젝트에 에셋 번들로 빌드해야 할 파일들이 매우 많은 경우에는 플랫폼 전환시 만만치않은 시간이 소요되기 때문에 플랫폼 전환 없이 빌드하는 방법이 필요하다.


문제점
------

여러 개의 Unity 에디터가 하나의 Unity 프로젝트 폴더에 접근할 수 없는 이유는 Unity 프로젝트 폴더의 *Temp*와 *Library* 폴더 때문이다. 

 * Temp - Unity 에디터의 시작 및 종료시 에디터 실행과 관련한 정보들을 담고 있는 폴더
 * Library - 플랫폼별 관련한 내용들을 저장하고 있는 폴더로 플롯폼 변환시 폴더의 내용도 함께 변경된다.

Unity 프로젝트에 대해서 여러 개의 Unity 에디터가 접근하는 경우 Temp 폴더와 Library 폴더에 여러 개의 Unity 에디터가 동시에 접근하는 경우 쓰기 오류가 발생한다. 

해결책
------
 
Temp 폴더와 Library 폴더를 공유하지 않으면 플랫폼 스위칭이 필요하지 않을 뿐만 아니라 여러 개의 Unity 에디터로 하나의 Unity 프로젝트를 병렬 처리하는 하는 것도 가능하다. 

이상의 사실로 플랫폼마다 미리 Library 폴더를 만들어 둔 다음 심볼릭 링크를 이용하면 실제 작업은 하나의 Unity 프로젝트 폴더 내에서 처리하고 에셋 번들 빌드시에는 플랫폼 스위칭 없이 빌드하는 것이 가능하다. 

1) 실제로 작업하는 Unity 프로젝트 폴더를 생성한다. 
2) 각 플랫폼별 폴더를 생성한다. 
3) 실제 작업하는 Unity 프로젝트 폴더의 Assets 폴더와 ProjectSettings 폴더를 심볼릭 링크(symbolic link)를 통해 각 플랫폼별 프로젝트 폴더 아래에 생성한다. 
4) 커맨드 라인에서 Unity 에디터의 실행을 통해서 각 플랫폼별로 필요한 에셋 번들을 빌드한다. 


심볼릭 링크(symbolic link)를 시용해서 여러 개의 Unity 에디터로 에셋 번들을 빌드하는 방법에 대해서 살펴 보자. 

먼저 아래와 같이 플랫폼별로 필요한 프로젝트의 폴더를 구성한다.

```
   Working
      | - Assets
      | - Library
      | - ProjectSettings
     iOS
      | -Assets ( Working/Assets의 심볼릭 링크 )
      | -Library
      | -ProjectSettings ( Working/ProjectSettings의 심볼릭 링크 )
   Android
      | -Assets ( Working/Assets의 심볼릭 링크 )
      | -Library 
      | -ProjectSettings ( WorkingProject/ProjectSettings의 심볼릭 링크 )
```

Working 프로젝토 폴더는 실제 작업이 이루어지는 폴더이고 iOS/Assets, iOS/ProjectSettings 폴더 및 Android/Assets, Android/ProjectSettings 폴더는 Working 프로젝트의 각 폴더의 심볼릭 링크로 만들어진 폴더이다. 

심볼릭 링크를 이용해서 플랫폼마다 폴더를 구성한 다음 반드시 Unity 에디터를 실행 시켜 각각의 프로젝트에서 빌드 설정(Build Settings)에서 해당 플랫폼으로 변경하도록 한다. 


윈도우즈에서 심볼릭 링크 만들기
-------------------------------

윈도우즈에서도 mklink를 이용하면 Unix에서처럼 심볼릭 링크를 사용할 수 있다. 

사용법은 아래와 같다. 
```
mklink /d(디렉토리 옵션) 대상폴더(혹은 파일) 원본폴더(혹은 파일)
```

디렉토리의 경우와 파일의 경우로 구분해서 사용한다. 디렉토리의 경우 /d 옵션이 필요하다. 명령행 창(command-line console)을 관리자 권한으로 열어 실행한다. 

디렉토리 심볼릭 링크를 이용해서 'Working\Assets' 폴더를 'iOS\Assets' 폴더로 링크한다. 
```
> mklink /d d:\github\Unity-AssetBundleTest\ProjectRoot\iOS\Assets d:\github\Unity-AssetBundleTest\ProjectRoot\Working\Assets
```


다음으로는 커맨더 라인 에디터에서 Unity 에디터를 실행하는 방법에 대해서 살펴 보자. 커맨더 라인 명령창에서 Unity 에디터는 다음의 방법으로 실행할 수 있다.
```
> Unity.exe -quit -batchmode -executeMethod [호출할 함수] -projectPath [프로젝트 경로]
```

 * -quit - 실행후 에디터를 종료. 
 * -batchmode - 에디터를 배치모드로 실행.
 * -executeMethod [호출할 함수] - *Editor* 폴더 아래에 위치한 에디터 스크립터의 정적함수만 호출 가능.
 * -projectPath [프로젝트 경로] - 실행할 Unity 프로젝트의 경로.

```csharp
static void  AssetbundleBuilder  () 
{ 
    ...
    BuildPipeline.BuildAssetBundle ( 
                obj,  
                new  Object{ obj }  
                string.Format ( " AB / {0} {1} .pack " ,  obj . name ,  EditorUserBuildSettings.activeBuildTarget ) 
                BuildAssetBundleOptions.CollectDependencies,  
                EditorUserBuildSettings.activeBuildTarget); 
}
```

에셋 번들 빌드를 위해서 에셋 번들을 빌드하는 에디터 스크립트를 다음과 같이 작성한다. 
``` csharp
public class ExportAssetbundle
{
    [MenuItem("Export/Assetbundle")]
    public static void Export()
    {
        // Note we don't put the assetbundle under the ./Assets/ project folder
        // because the project folder is already linked with symbolic link.
        string path = Application.dataPath + "/../Bundles/";

        // See the directory is exist, if not, it makes a new one.
        if (!Directory.Exists(path))
            Directory.CreateDirectory(path);

        // Build assetbundles
        BuildPipeline.BuildAssetBundles(path);
    }
}
```

iOS와 Android의 Assets 폴더는 심볼릭 링크로 만들어진 폴더이므로 에셋 번들 빌드시 빌드한 에셋 번들이 Assets/ 폴더 아래에 만들어지지 않도록 주의한다.

각 플랫폼 에셋 번들의 빌드는 배치 파일을 만들어서 실행하면 편리하다. 


```
rem Build iOS platform assetbundles under the ./iOS/Bundles directory.

set PRJ_PATH=%cd%\iOS
@echo %PRJ_PATH%

Unity.exe -quit -batchmode -executeMethod ExportAssetbundle.Export -projectPath %PRJ_PATH%
```

배치파일들은 ProjectRoot 폴더 아래에 플랫폼별 배치파일들을 찾을 수 있다. 

