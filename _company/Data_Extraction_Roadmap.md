<content># Data Extraction Roadmap (T2) - Phase별 기술 설계 및 인터페이스 정의

## 1. 목표
PostgreSQL DB 스키마 V1을 기반으로, 정부 및 공공기관 연구과제 관련 데이터를 안정적이고 자동화된 방식으로 추출하고 정제하는 파이프라인 구축.

## 2. Phase 1: Data Ingestion & Extraction (수집 단계)
**목표:** 정의된 데이터 소스(API, 웹 크롤링 등)로부터 원천 데이터를 수집하는 모듈 설계.

### 2.1. 기술 스택 정의
*   **핵심 기술:** Python (FastAPI/Django for orchestration), Scrapy (for complex crawling), Custom API Clients.
*   **데이터 수집 모듈:** 각 타겟 기관별로 요구되는 추출 방식(정적 API, 동적 크롤링)에 따라 모듈 분리.
*   **인터페이스 정의 (API/Hook Specification):**
    *   `ExtractorInterface`: 모든 추출 모듈이 준수해야 할 공통 인터페이스 정의. (예: `extract(source_config) -> List[RawData]`)
    *   `SourceSpecificHook`: 특정 기관/소스에 맞는 실제 데이터 요청 및 파싱 로직. (예: `extract_gov_api(endpoint, params)`)

### 2.2. Phase 1 상세 설계 (Researcher SOP 매핑)
*   **Step 1: Source Identification:** 타겟 기관별 데이터 소스 목록 정의 및 접근 권한(API Key/Credential) 관리 모듈 설계.
*   **Step 2: Data Retrieval:** `SourceSpecificHook`을 사용하여 데이터를 수집. **(여기서 DB 스키마 V1의 입력 매핑이 필수적으로 이루어져야 함)**
*   **Output Format:** Raw JSON/XML -> Standardized Intermediate Format.

## 3. Phase 2: Data Transformation & Validation (정제 단계)
**목표:** 수집된 원천 데이터를 DB 스키마 V1에 맞게 정제하고, 데이터 품질을 검증하는 모듈 설계. (Researcher SOP의 '정제' 단계에 해당)

### 3.1. 기술 스택 정의
*   **핵심 기술:** Pandas/Pydantic for structured validation, Custom Transformation Logic.
*   **Validation Module:** Pydantic 모델을 활용하여 수집된 데이터의 형식, 필수 값 누락 여부 검증.
*   **Transformation Module:** 원천 데이터의 비정형/오류 데이터를 DB 스키마 V1의 타입(Data Type) 및 제약 조건에 맞게 변환하는 로직 구현.

### 3.2. Phase 2 상세 설계
*   **Step 1: Schema Mapping:** Raw Data Field $\rightarrow$ PostgreSQL Column Mapping Table 정의. (DB 스키마 V1과 1:1 매핑 검증)
*   **Step 2: Data Cleaning:** Null 값 처리 전략 (Imputation/Deletion), 데이터 타입 변환 로직 구현.
*   **Step 3: Integrity Check:** 정의된 제약 조건(Foreign Key 관계, Not Null) 위반 여부 검증 로직 구현.

## 4. Phase 3: Data Loading & Monitoring (적재 및 모니터링 단계)
**목표:** 정제된 데이터를 PostgreSQL DB에 안정적으로 적재하고, 파이프라인의 상태를 모니터링하는 메커니즘 설계.

### 4.1. 기술 스택 정의
*   **핵심 기술:** SQLAlchemy/Alembic (DB Migration), Transaction Management.
*   **Loading Module:** Bulk Insert/Upsert 전략 사용.
*   **Monitoring Module:** Logging Framework (e.g., ELK stack integration), Alerting System (Slack/Email Hook).

### 4.2. Phase 3 상세 설계
*   **Step 1: Bulk Loading:** 정제된 데이터를 PostgreSQL에 삽입/업데이트. 트랜잭션 단위로 작업 분할.
*   **Step 2: Error Handling:** 로딩 실패 시, 재시도(Retry) 메커니즘 및 에러 로그 기록.
*   **Step 3: Health Check:** 파이프라인의 주기적인 실행 및 상태 보고 (Success/Failure) 메커니즘 정의.

---
**✅ 검토 사항:** DB 스키마 V1과의 매핑 정확성, Phase 1/2 간의 데이터 흐름 검증 필요.

</content>