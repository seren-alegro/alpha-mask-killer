from PIL import Image
import os
from pathlib import Path

def remove_alpha_channel(input_path, output_path, background_color=(255, 255, 255)):
    """
    PNG 이미지의 알파 채널을 제거합니다.
    """
    try:
        img = Image.open(input_path)

        # RGB로 변환
        if img.mode in ('RGBA', 'LA', 'P'):
            background = Image.new('RGB', img.size, background_color)
            if img.mode == 'P':
                img = img.convert('RGBA')
            if img.mode in ('RGBA', 'LA'):
                background.paste(img, mask=img.split()[-1])
            else:
                background.paste(img)
            img = background
        else:
            img = img.convert('RGB')

        # PNG로 저장하되 RGB 모드 강제
        img.save(output_path, 'PNG')
        print(f"✓ 처리 완료: {os.path.basename(input_path)}")
        return True
    except Exception as e:
        print(f"✗ 오류 발생 ({os.path.basename(input_path)}): {e}")
        return False

def process_folder_recursive(input_folder, output_folder=None, background_color=(255, 255, 255)):
    """하위 폴더까지 모두 처리"""
    input_path = Path(input_folder)

    if output_folder:
        output_path = Path(output_folder)
        output_path.mkdir(parents=True, exist_ok=True)
    else:
        output_path = input_path

    png_files = list(input_path.rglob('*.png'))

    if not png_files:
        print("PNG 파일을 찾을 수 없습니다.")
        return

    print(f"총 {len(png_files)}개의 PNG 파일을 찾았습니다.\n")

    success_count = 0
    for png_file in png_files:
        # 상대 경로 유지
        relative_path = png_file.relative_to(input_path)

        if output_folder:
            output_file = output_path / relative_path
            output_file.parent.mkdir(parents=True, exist_ok=True)
        else:
            output_file = png_file

        if remove_alpha_channel(str(png_file), str(output_file), background_color):
            success_count += 1

    print(f"\n완료: {success_count}/{len(png_files)} 개 파일 처리")

# 결과를 다른 폴더에 저장
process_folder_recursive('alpha mask killer', 'alpha mask killer_output')
