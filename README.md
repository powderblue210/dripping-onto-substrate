# DoS(dripping-onto-substrate)
DoS(Dripping-onto-Substrate) 결과에서 R/R0 데이터 추출 방법

실행 전 반드시 **유의사항** 확인!!
<br><br>

## 사용방법

### 0. 이미지 전처리 (Upsampling) 방법

해당 Github Repository에 올린 `upsampling.py` 다운로드

cmd(명령 프롬프트) 실행 후, cmd에 `cd (upsampling.py를 다운로드 받은 파일 경로)` 명령어 입력

(ex. `cd "C:\Users\UserPC\Dos"` )

cmd에서 `python upsampling.py` 명령어 입력

팝업창에서 순서대로 입력 폴더(원본 이미지)와 출력 폴더(해상도 처리 후이미지) 선택
<br><br>

### 1. ImageJ/Fiji 다운로드

Fiji Downloads 공식 웹사이트: https://imagej.net/software/fiji/downloads

해당 웹사이트에서 우측 `STABLE DOWNLOADS`에서 본인 OS에 맞는 버전을 다운로드 (좌측 `LATEST DOWNLOADS`는 아님!!)

**주의사항!!** 압축해제 시 `C:\Program Files`에 둘 경우 에러 발생 가능하므로 별도 폴더에 압축 해제

( ex. Fiji라는 별도 폴더를 만들고 `C:\Fiji`에 다운로드받은 폴더의 압축 해제 )
<br><br>

다운로드 이후 fiji라고 표시되는 "응용 프로그램" 실행 ( 정상 실행 시 가로로 긴 툴바가 표시됨. )
<br><br>

### 2. filament_analysis.ijm 파일 다운로드

해당 Github Repository에 올린 `filament_analysis.ijm` 파일 다운로드 ( Fiji에서 실행할 매크로 파일 )
<br><br>

### 3. Macro 실행

Macro 실행 시 각 실험마다 다음을 순서대로 실행: 

Fiji 실행한 상태에서 가로로 긴 툴바에서 `Plugins > Macros > Run...` 선택

첫 번째 팝업창 (`Run Macro or Script...`)이 뜨면 **2.** 에서 다운로드 받은 filament_analysis.ijm 파일 선택

두 번째 팝업창 (`Select Source Directory`)이 뜨면 실험 데이터가 저장된 폴더 선택

세 번쨰 팝업창 (`Select Output Directory`)이 뜨면 결과 데이터를 저장할 폴더 선택
<br><br>

`filament_analysis.ijm`: csv 및 모든 데이터에 대해 경계선 처리된 이미지 복사본을 저장

`filament_csv.ijm`: 데이터에 대해 `R_pixel` 값만 csv 형태로 저장 (이미지 저장 X)

(`filament_csv.ijm`의 경우 추후 mm/pixel 값 계산해서 R0_pixel 값을 구한 후 R/R0값 계산 가능)
<br><br>

### 4. Macro 코드 수정

실험 환경에 따라 `filament_analysis.ijm` 의 설정값을 변경해야 할 수 있습니다.

- 필라멘트 경계선 밝기값: 코드 8째줄 `thresholdVal` 값 수정

- fps에 따른 Sampling Rate: milisecond 기준으로 코드 9째줄 `dt` 값 수정
<br><br>

### 5. Threshold 값 확인 방법

**4.** 에서 적절한 `thresholdVal` 값을 확인하는 방법은 다음과 같습니다.
<br><br>

Fiji 실행한 상태에서 툴바에 원본 이미지 파일 Drag&Drop

이미지 파일이 뜬 상태에서 `Image > Type` 에서 **반드시 8-bit** 선택하여 변경 후,

`Image > Adjust > Threshold...` 선택 ( 혹은 단축어 `Ctrl + Shift + T`)

`Threshold` 창이 뜨면 두 번째 사이드바를 이동시키며 Filament 영역에 해당하는 경계선의 밝기값 확인 (범위는 0~225)

적절한 경계값 확인 후 해당 값을 `filament_analysis.ijm`의 코드 8째줄 `thresholdVal` 에 작성
<br><br>

## 유의사항

- 결과 데이터를 저장할 폴더는 미리 `새 폴더`로 만들어둬야 함

- 폴더 안 이미지 데이터 저장면 **반드시 사전순(Lexicographical Order)로 정렬** 되어 있어야 함!! (ex. img_001, img_002, ... , img_999)
 










