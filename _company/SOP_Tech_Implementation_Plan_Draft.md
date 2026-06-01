# 데이터 추출 SOP 기술 구현 분배 가이드라인 (Draft)

## 🎯 작업 결정 및 분배 계획

**선택된 단일 작업:** 확정된 DB 스키마를 기반으로, 데이터 추출 SOP(T2)의 기술 구현 분배 계획 수립.

**이유:** CEO의 지시는 '확정된 DB 스키마를 기반으로, 데이터 추출 SOP(T2)의 기술 구현 분배 계획 수립'이며, 이는 현재 DB 스키마 설계(T1)의 다음 단계이자 개발팀과의 협업을 위한 핵심 산출물입니다. Researcher의 역할은 이 기술적 워크플로우 가이드라인을 구체화하는 것입니다.

**분배 대상 에이전트:**
1.  **Researcher (본인):** 전체 기술 워크플로우의 논리적 구조 설계 및 단계별 책임 정의.
2.  **Developer (협업 대상):** 각 단계별 기술 구현 세부사항(API 호출, 데이터 정제 로직)의 초안 작성 및 검토.

**산출물 목표:**
Developer가 즉시 실행할 수 있도록, 데이터 추출 프로세스(수집 $\rightarrow$ 정제 $\rightarrow$ 매핑)의 명확한 단계별 책임(RACI 또는 유사 구조), 사용될 기술 스택 제안, 그리고 각 단계의 예상 산출물 정의가 포함된 **'데이터 추출 SOP 기술 구현 분배 가이드라인(Draft)'**을 작성합니다.

### 1. 개요 및 목표

**목표:** PostgreSQL DB 스키마(`[스키마 명시 필요]`)를 활용하여, 정부 및 공공기관의 연구과제 데이터를 안정적이고 효율적으로 변환하는 End-to-End 기술 워크플로우를 정의한다.

**핵심 원칙:** 모듈화(Modularization) 및 단계별 책임 분배(Stage-Gate Process). 각 단계는 명확한 입력(Input)과 출력(Output)을 가지며, Developer와 Researcher 간의 인터페이스 정의가 명확해야 한다.

### 2. 기술 워크플로우 단계별 분배 (Phase Breakdown)

| 단계 (Phase) | 주요 목표 (Goal) | 책임자 (Owner) | 상세 작업 내용 (Task Details) | 필수 입력 (Input) | 예상 출력 (Output) |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **Phase 1: 데이터 수집 (Acquisition)** | 타겟 기관별 데이터 소스 접근 경로 확정 및 기본 추출 구현. | Developer (주도), Researcher (검토) | 1. **API/크롤링 경로 검증:** Researcher가 정의한 접근 경로의 안정성 테스트. 2. **초기 데이터 추출 모듈 개발:** 타겟 기관별 API 호출 및 기본 응답 수신 기능 구현. | DB 스키마 (T1), 최적화된 API/웹 접근 경로 목록 (Researcher) | 데이터 추출 모듈(MVP), 추출 성공률 측정 지표. |
| **Phase 2: 데이터 정제 (Cleaning & Validation)** | 수집된 원시 데이터를 비즈니스 요구사항에 맞게 구조화하고 오류를 제거. | Developer (주도), Researcher (규칙 정의) | 1. **데이터 정제 로직 구현:** 결측치 처리, 형식 변환(날짜, 숫자), 중복 제거 로직 개발. 2. **데이터 유효성 검사 규칙 정의:** Researcher가 정의한 품질 기준(Schema Definition v1.0 기반)에 따른 검증 로직 구현. | Phase 1 출력 (Raw Data), Schema Definition v1.0 | 정제된 데이터셋(Cleaned Dataset), 정제 과정의 상세 로깅 메커니즘. |
| **Phase 3: 데이터 매핑 및 통합 (Mapping & Integration)** | 정제된 데이터를 최종 분석/보고서 포맷에 맞게 구조적으로 매핑. | Researcher (주도), Developer (구현) | 1. **데이터 매핑 규칙 정의:** 정제된 컬럼을 최종 보고서 요구사항(Goal)에 맞게 매핑하는 로직 설계. 2. **통합 모듈 개발:** 최종 데이터셋을 보고서 포맷(예: JSON, CSV)으로 변환하는 모듈 구현. | Phase 2 출력 (Cleaned Dataset), 최종 보고서 요구사항 정의 | 최종 분석용 데이터셋(Final Dataset), 보고서 포맷 변환 모듈. |
| **Phase 4: 보고 및 피드백 (Reporting & Feedback)** | 전체 파이프라인의 안정성 검증 및 개선점 도출. | Researcher (주도), 전원 | 1. **통합 테스트:** 전체 파이프라인 End-to-End 테스트 수행. 2. **성능 및 안정성 리포트:** 각 단계별 병목 현상 분석 및 개선 필요 사항 도출. | Phase 3 출력 (Final Dataset) | 최종 검증된 SOP 문서, 개선 요구사항 리스트. |

### 3. 협업 가이드라인 (Interface Definition)

*   **API/인터페이스 정의:** 각 Phase의 입력과 출력은 명확한 **JSON 스키마**로 정의되어야 한다. Developer는 이 스키마를 기준으로 모듈 인터페이스를 개발해야 하며, Researcher는 이 스키마의 **비즈니스 로직적 의미**를 검토하고 승인해야 한다.
*   **기술 스택 제안:** Phase 1, 2에서 사용될 핵심 기술(Python 라이브러리, 데이터베이스 접근 방식 등)에 대해 Developer가 제안하고, Researcher는 회사 인프라 및 보안 가이드라인에 부합하는지 검토한다.
*   **진행 상황 보고:** 매 Phase 종료 시, Developer는 **'Phase X 완료 리포트'**를 작성하여 Researcher에게 전달하며, 이 보고서에는 성공 지표(KPI)와 발견된 문제점(Blockers)을 명시해야 한다.

### 4. 다음 단계 (Action Items for Developer & Researcher)

*   **Developer:** Phase 1의 '초기 데이터 추출 모듈 개발'을 위한 **기술 스택(언어, 프레임워크) 제안**과 초기 API/크롤링 시나리오 초안을 작성하십시오.
*   **Researcher:** Phase 2의 '데이터 유효성 검사 규칙 정의'를 위해, **Schema Definition v1.0의 각 컬럼에 대한 비즈니스/규제적 검증 기준**을 상세하게 작성하여 Developer에게 전달하십시오.