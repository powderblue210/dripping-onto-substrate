# DoS(dripping-onto-substrate)
DoS(Dripping-onto-Substrate) 결과에서 R/R0 데이터 추출 방법

실행 전 반드시 **유의사항** 확인!!
<br><br>

## 사용방법

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

### 4. Macro 코드 수정

실험 환경에 따라 `filament_analysis.ijm` 의 설정값을 변경해야 할 수 있습니다.

- 필라멘트 경계선 밝기값: 코드 8째줄 `thresholdVal` 값 수정

- fps에 따른 Sampling Rate: milisecond 기준으로 코드 9째줄 `dt` 값 수정
<br><br>

## 유의사항

- 결과 데이터를 저장할 폴더는 미리 `새 폴더`로 만들어둬야 함

- 폴더 안 이미지 데이터 저장면 **반드시 사전순(Lexicographical Order)로 정렬** 되어 있어야 함!! (ex. img_001, img_002, ... , img_999)
 










