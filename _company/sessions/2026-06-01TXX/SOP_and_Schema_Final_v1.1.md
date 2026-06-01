# SOP 및 최종 Schema 정의 (ALTIT KOREA)

## 📄 SOP 상세 워크플로우 v1.1

**목표:** 정부 및 공공기관 연구과제 데이터의 안정적이고 정량화된 수집 및 분석을 위한 표준 운영 절차 확립.

**1. 데이터 소스 탐색 및 접근 (Phase 1: Discovery & Access)**
*   **목표:** 최우선 타겟 기관별 데이터 접근 경로(API/Web)의 **실시간 유효성**을 확인한다.
*   **프로세스:**
    1.  타겟 기관별 접근 경로 목록 확인 (Researcher 제공).
    2.  **[수정 사항] 실시간 접근 가능성 검증 (Live Test):** 각 경로에 대해 최소 3회 이상 연속적인 데이터 추출 성공 테스트(Dry Run)를 의무화한다.
    3.  접근 경로의 변경 주기(Update Frequency)를 기록하고, 변경 시 즉시 알림을 발생시킨다.
    4.  **[위험 관리]**: 접근 실패 시, 즉시 차선책(Fallback Plan)을 발동하고, Researcher에게 변경 사항을 보고한다.

**2. 데이터 추출 및 수집 (Phase 2: Extraction)**
*   **목표:** 확정된 접근 경로를 기반으로 연구과제 데이터를 안정적으로 추출한다.
*   **프로세스:**
    1.  모듈별(기관별)로 설계된 데이터 추출 모듈을 실행한다.
    2.  **[수정 사항] 봇 감지 회피 전략 적용:** 웹 크롤링 시, 요청 간 지연 시간(Delay)을 최소 5초 이상으로 설정하고, User-Agent를 주기적으로 변경하여 비정상적인 트래픽을 회피한다.
    3.  추출된 원시 데이터는 **'데이터 정합성 검증 모듈(Validation Module)'**로 즉시 이관한다.

**3. 데이터 정제 및 표준화 (Phase 3: Cleaning & Standardization)**
*   **목표:** 수집된 원시 데이터를 최종 Schema에 맞추어 정제하고, ALTIT 매칭 점수 계산을 위한 전처리 작업을 수행한다.
*   **프로세스:**
    1.  데이터 정합성 검증 모듈이 **Schema 정의 (아래 참조)**와 일치하는지 검사한다.
    2.  **[수정 사항] ALTIT 매칭 점수 계산:** Researcher가 정의한 $\text{altit\_match\_score}$ 공식에 따라 각 컬럼의 정규화 점수($S_i$)를 산출한다.
    3.  데이터 품질 불일치 시, $\text{Penalty}(\text{DataQuality})$를 적용하여 최종 점수를 조정한다.

**4. 기술적 분배 및 모듈화 (Phase 4: Distribution & Deployment)**
*   **목표:** 데이터 파이프라인의 각 단계별 기술 스택과 담당자를 최종 확정하고 배포 계획을 수립한다.
*   **프로세스:**
    1.  코다리 에이전트가 최종 DB 스키마 기반으로 모듈별(API/크롤링/정제) **기술적 분배 계획**을 확정한다.
    2.  각 모듈에 대한 기술적 난이도 및 리스크를 평가하고, 팀/개인별 숙련도를 고려하여 최종 분배한다.

**5. 피드백 및 반복 (Phase 5: Feedback & Iteration)**
*   **목표:** 지속적인 품질 향상을 위한 체계적인 피드백 루프를 구축한다.
*   **프로세스:**
    1.  데이터 품질 불일치 또는 추출 실패 발생 시, 즉시 **Researcher $\rightarrow$ 코다리 피드백 루프**를 활성화한다.
    2.  피드백은 SOP v1.1의 **'수정 사항 3'**에 따라, 문제 해결을 위한 구체적인 수정 지침으로 변환되어야 한다.

---

## 📊 최종 데이터 요구사항 (Schema Definition) v1.0

**(코다리 에이전트에게 전달)**

| 필드명 (Column Name) | 데이터 타입 (Data Type) | 필수 여부 | 설명 (Description) | ALTIT 매칭 가중치 ($W_i$) | 데이터 출처 (Source) | 비고 (Notes) |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| `project_id` | VARCHAR(50) | 필수 | 해당 연구과제의 고유 식별자. | N/A | 기관 제공 | Primary Key |
| `institution_code` | VARCHAR(20) | 필수 | 연구 과제를 등록한 기관의 고유 코드. | 1.5 | 기관 제공 | 타겟기관별 매핑 필수 |
| `title` | TEXT | 필수 | 연구과제의 공식 제목. | 2.0 | 기관 제공 | 핵심 정보 |
| `category_code` | VARCHAR(30) | 필수 | 연구과제의 세부 분야 코드 (예: AI, ICT, Bio 등). | 1.8 | 기관 제공 | 분류 정확도 중요 |
| `submission_date` | DATE | 필수 | 연구과제 제출 또는 등록일. | 1.2 | 기관 제공 | 시의성 분석용 |
| `funding_source` | VARCHAR(100) | 선택 | 해당 과제에 배정된 정부/공공기관 자금원. | 1.0 | 기관 제공 | 재원 분석용 |
| `keywords` | TEXT[] | 선택 | 과제 관련 핵심 키워드 목록. | 0.8 | 기관 제공 | 검색 최적화용 |
| `research_status` | VARCHAR(50) | 필수 | 현재 연구 단계 (예: 기획, 수행 중, 완료). | 1.7 | 기관 제공 | 진행 상황 추적 |
| `complexity_score` | INTEGER | 필수 | 연구의 기술적/정책적 난이도 (1~5 척도). | 2.5 | 내부 평가 (Researcher) | AMS 핵심 지표 |
| `altit_match_score` | FLOAT | 필수 | **ALTIT 매칭 점수**. 정의된 가중치 합산 결과. | N/A | 내부 계산 (Researcher) | **최종 핵심 지표** |
| `extracted_summary` | TEXT | 선택 | 기관이 제공한 요약 설명. | 0.5 | 기관 제공 | 정제 필요 |
| `access_url` | VARCHAR(200) | 선택 | 원본 정보로 직접 연결되는 URL. | 1.3 | 기관 제공 | 검증용 |

**ALTIT 매칭 점수 ($\text{altit\_match\_score}$) 계산 로직 (Researcher 정의)**

$$\text{altit\_match\_score} = \sum_{i=1}^{n} (W_i \times S_i) + \text{Penalty}(\text{DataQuality})$$

*   $S_i$: 컬럼 $i$의 정규화된 점수 (0~1 사이).
*   $W_i$: 컬럼 $i$의 중요도 가중치 (위 표 참조).
*   $\text{Penalty}(\text{DataQuality})$: 데이터의 불일치(예: 제목 길이, 날짜 형식 오류)에 대해 0.1 ~ 0.5 사이에서 동적으로 할당되는 페널티 값.