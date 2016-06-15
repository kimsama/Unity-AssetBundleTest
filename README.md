# Unity-AssetBundleTest

문제점
======

여러 개의 Unity 에디터가 하나의 Unity 프로젝트 폴더에 접근할 수 없는 이유는 Unity 프로젝트 폴더의 *Temp*와 *Library* 폴더 때문이다. 

 * Temp - Unity 에디터의 시작 및 종료시 에디터 실행과 관련한 정보들을 담고 있는 폴더
 * Library - 플랫폼별 관련한 내용들을 저장하고 있는 폴더로 플롯폼 변환시 폴더의 내용도 함께 변경된다.

Unity 프로젝트에 대해서 여러 개의 Unity 에디터가 접근하는 경우 Temp 폴더와 Library 폴더에 여러 개의 Unity 에디터가 동시에 접근하는 경우 쓰기 오류가 발생한다. 

해결책
======
 
Temp 폴더와 Library 폴더를 공유하지 않으면 여러 개의 Unity 에디터로 하나의 Unity 프로젝트를 병렬 처리하는 하는 것이 가능하다. 




AssetBundle 빌드
================

플롯폼 전환시 매우 많은 시간이 소요!

```
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

```
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


커맨더 라인 에디터에서 Unity 에디터를 실행, 에셋 번들 빌드 시간을 단축하는 방법.

우선 커맨더 라인 명령창에서 Unity 에디터를 실행하는 방법
```
> Unity.exe -buildTarget [플랫폼] -quit -batchmode -executeMethod [호출할 함수] -projectPath [프로젝트 경로]
```

 * -buildTarget [플랫폼] 
 * -quit 
 * -batchmode 
 * -executeMethod [호출할 함수] 
 * -projectPath [프로젝트 경로]

```
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

symbolic link를 시용해서 여러 개의 Unity 에디터로 에셋 번들을 빌드하는 방법. 

```
BaseProject
      | - Assets
      | - Library
      | - ProjectSettings
iOS-Build
      | -Assets (BaseProject / Assets의 심볼릭 링크 )
      | -Library
      | -ProjectSettings (BaseProject / ProjectSettings의 심볼릭 링크 )
iOS-Build2
      | -Assets (BaseProject / Assets의 심볼릭 링크 )
      | -Library ( iOS Build / Library의 심볼릭 링크 )
      | -ProjectSettings (BaseProject / ProjectSettings의 심볼릭 링크 )
```

