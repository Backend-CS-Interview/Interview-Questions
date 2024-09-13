#!/bin/bash

README_FILE="java_interview.md"

# README 파일에서 변경된 줄만 가져오기 (스테이징 여부 상관없음)
CHANGES=$(git diff main...HEAD $README_FILE | grep '^+[^+]')

# 변경 사항이 있는 경우
if [ -n "$CHANGES" ]; then
    # 추가된 내용을 출력
    echo "README 파일에 추가된 내용:"
    echo "$CHANGES"
else
    echo "README 파일에 변경 사항이 없습니다."
fi
