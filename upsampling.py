import os
import sys
import cv2
import numpy as np
from tqdm import tqdm
import tkinter as tk
from tkinter import filedialog

def select_directories():
    ## 파일 선택 창 생성
    root = tk.Tk()
    root.withdraw()
    root.attributes('-topmost', True) 

    # Input Directory 선택
    input_path = filedialog.askdirectory(title="원본(TIFF) 이미지 폴더 선택")
    if not input_path:
        print("입력 폴더가 선택되지 않아 프로그램을 종료합니다.")
        sys.exit()

    # 2. Output Directory 선택
    output_path = filedialog.askdirectory(title="Upsampling결과 저장폴더 선택")
    if not output_path:
        print("출력 폴더가 선택되지 않음. 프로그램 종료")
        sys.exit()

    return input_path, output_path

## 메인 실행
folder_path, output_path = select_directories()

print(f"\n[선택된 경로]")
print(f" - 입력 폴더: {folder_path}")
print(f" - 출력 폴더: {output_path}\n")

# 저장 폴더가 없으면 자동 생성
os.makedirs(output_path, exist_ok=True)

# 폴더 내 파일 목록 가져오기 (TIFF 확장자 기준 및 정렬)
file_list = [f for f in os.listdir(folder_path) if f.lower().endswith(('.tif', '.tiff'))]
file_list.sort()

if not file_list:
    print(f"경로에 처리할 TIFF 파일이 없습니다: {folder_path}")
else:
    print(f"총 {len(file_list)}개의 파일을 업샘플링합니다.")

    # tqdm을 활용한 반복문 처리
    for filename in tqdm(file_list, desc="Upsampling Progress"):
        file_path = os.path.join(folder_path, filename)
        
        # 이미지 불러오기 (원래 비트 깊이 및 형식 유지)
        img_orig = cv2.imread(file_path, cv2.IMREAD_UNCHANGED)
        
        if img_orig is None:
            print(f"\n경고: 파일을 읽지 못했습니다 - {filename}")
            continue

        # cv2.pyrUp을 두 번 연속 적용하여 4배 업샘플링
        img_up_2x = cv2.pyrUp(img_orig)
        img_upsampled = cv2.pyrUp(img_up_2x)

        # 지정된 업샘플링 폴더에 저장
        save_file_path = os.path.join(output_path, filename)
        cv2.imwrite(save_file_path, img_upsampled)

    print(f"\n모든 이미지 업샘플링이 완료되었습니다.")
    print(f"저장 위치: {output_path}")