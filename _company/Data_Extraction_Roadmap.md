# 데이터 추출 자동화 (T2) 기술 로드맵

이 문서는 PostgreSQL DB 스키마 V1을 기반으로, 연구과제 데이터 추출 자동화(T2)를 구현하기 위한 Phase별 기술 설계 로드맵입니다.

## 목표
PostgreSQL DB 스키마(V1)에 맞춰, 외부 소스에서 데이터를 수집, 정제, 검증하여 DB에 안정적으로 삽입하는 파이프라인을 구축합니다.

## Phase 1: 인프라 및 인터페이스 정의 (Foundation)
**목표:** DB 스키마와 외부 데이터 소스 간의 통신 프로토콜을 정의하고, 최소한의 추출 기능을 구현할 수 있는 환경을 구축합니다.

**기술 스택:**
*   **DB/Schema:** PostgreSQL (스키마 V1 기반)
*   **API Interface Definition:** OpenAPI/Swagger 명세 작성 (외부 데이터 제공처와의 통신 규격 정의)
*   **Initial Data Extraction Module:** Python (Requests/Scrapy 기반), Pydantic 모델을 이용한 데이터 유효성 검사.

**세부 Task:**
1.  **API Endpoint 명세 확정:** Researcher가 제공할 데이터 소스별로 필요한 API 엔드포인트(URL, 인증 방식) 명세화.
2.  **Phase 1 Data Structure Mapping:** PostgreSQL 테이블의 각 필드(`project_code`, `submission_date` 등)에 매핑될 외부 데이터 항목 정의.
3.  **Phase 1 Schema Validation:** Pydantic 모델을 사용하여 수집된 데이터가 DB 스키마의 제약 조건(데이터 타입, 필수 여부)을 만족하는지 검증하는 로직 구현.
4.  **Extraction Hook Implementation:** 최소 1개 타겟 기관의 샘플 데이터를 성공적으로 추출하여 PostgreSQL에 삽입하는 End-to-End 테스트 환경 구축.

**기술 난이도 (Complexity Score):** Medium
*   외부 API 구조에 따라 변동성이 크므로, 초기에는 고정된 소스(예: 공개 API)로 시작하여 유연성을 확보해야 합니다.

## Phase 2: 핵심 데이터 추출 및 정제 (Core Implementation)
**목표:** Phase 1에서 정의된 인터페이스를 기반으로, 실제 데이터를 안정적으로 추출하고 데이터 정제(Cleaning) 과정을 자동화합니다.

**기술 스택:**
*   **Data Pipeline Framework:** Apache Airflow 또는 자체 Python 기반의 동기/비동기 큐 시스템 (예: Celery).
*   **Data Cleaning:** Pandas/Polars를 활용한 대용량 데이터 정제 및 이상치 처리.
*   **Error Handling:** 재시도(Retry) 메커니즘 및 실패 시 알림 시스템 (Slack/Email 연동).

**세부 Task:**
1.  **Data Source Specific Extraction Modules (N개):** 각 타겟 기관/소스별로 Phase 1에서 정의한 Hook을 사용하여 데이터를 추출하는 모듈 개발.
2.  **Data Transformation Pipeline:** 추출된 원시 데이터(Raw Data)를 PostgreSQL 스키마에 맞게 구조화하고 정규화하는 변환 로직 구현.
3.  **Data Quality Assurance (DQA):** AMS 가중치 로직(`ams_weights` 테이블 참조)을 활용하여 추출된 데이터의 품질을 실시간으로 평가하는 모듈 개발.
4.  **Logging Integration:** `extraction_logs` 테이블에 모든 추출 및 정제 단계를 상세히 기록하도록 로깅 시스템 통합.

**기술 난이도 (Complexity Score):** High
*   다양한 외부 소스의 비정형 데이터를 처리해야 하므로, 견고한 에러 핸들링과 데이터 정합성 확보에 집중해야 합니다.

## Phase 3: 자동화 및 운영 (Deployment & Monitoring)
**목표:** 전체 파이프라인을 완전 자동화하고, 운영 환경에서 모니터링 및 유지보수가 용이하도록 시스템을 안정화합니다.

**기술 스택:**
*   **Orchestration:** Airflow (복잡한 의존성 관리 및 스케줄링).
*   **Monitoring:** Prometheus/Grafana (시스템 상태 모니터링), Log aggregation (ELK Stack).
*   **Infrastructure:** Docker/Kubernetes 기반의 컨테이너화 및 CI/CD 파이프라인 구축.

**세부 Task:**
1.  **CI/CD Pipeline Setup:** 코드 변경 시 자동 테스트 및 배포(Docker Image 빌드 포함) 프로세스 구축.
2.  **Production Deployment:** Phase 2에서 검증된 파이프라인을 운영 환경에 배포.
3.  **Operational Monitoring Setup:** 추출 실패율, 데이터 지연 시간, 시스템 리소스 사용량에 대한 알림 체계 확립.
4.  **Maintenance Protocol Definition:** 데이터 소스 변경 및 API 변경에 대비한 유지보수 절차 문서화.

**기술 난이도 (Complexity Score):** High
*   운영 안정성 확보가 최우선 목표입니다.

---
**Developer의 다음 액션:**
Phase 1의 **API Endpoint 명세 확정 (Task 1)**을 위해 Researcher에게 필요한 구체적인 데이터 소스 목록 및 접근 경로 정보를 요청해야 합니다. 이 정보가 있어야 Phase 1의 Pydantic 모델과 Extraction Hook 설계를 시작할 수 있습니다.