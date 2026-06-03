# 🏗️ PostgreSQL DB 스키마 V1: 기술 프레임워크 초안

**목표:** 데이터 추출 모듈 구현의 기반이 될, 연구과제 데이터 저장 구조의 개념적 설계(Conceptual Design)를 확립한다.

**1. 설계 원칙 (Recap)**
*   Extensibility First: 모듈화된 데이터 소스 접근을 허용.
*   Data Integrity: 관계형 무결성을 통한 데이터 정합성 확보.
*   API Contract Decoupling: Pydantic 모델을 통한 데이터 정의의 분리.

**2. 핵심 엔티티 (Core Entities)**
| 엔티티명 | 주요 역할 | 핵심 필드 (예시) | 관계 타입 | 비고 |
| :--- | :--- | :--- | :--- | :--- |
| `Institution` (기관) | 데이터의 출처 정의 및 관리 | `id`, `name`, `access_type` (API/Web), `priority_score` | 1:N (과제) | 데이터 소스 메타 정보 |
| `ResearchProject` (연구과제) | 핵심 연구 데이터 저장 | `id`, `project_name`, `institution_id (FK)`, `status`, `funding_source` | N:1 (기관) | 연구과제의 기본 정보 |
| `ProjectDetail` (세부내역) | 상세 요구사항 및 매핑 데이터 | `id`, `project_id (FK)`, `data_field_1`, `data_field_2`... | 1:N (과제) | Researcher가 정의한 13개 핵심 필드 매핑 공간. Extensibility의 핵심. |
| `ValidationLog` (검증 로그) | 데이터 추출 및 검증 이력 추적 | `id`, `project_detail_id (FK)`, `extraction_timestamp`, `source_url`, `validation_status` | 1:1 (세부내역) | 데이터 추출의 투명성 및 디버깅 용이성 확보. |

**3. 관계 다이어그램 (Conceptual Relationship)**
*   `Institution` $\longleftrightarrow$ `ResearchProject` (1:N)
*   `ResearchProject` $\longleftrightarrow$ `ProjectDetail` (1:N)
*   `ProjectDetail` $\longleftrightarrow$ `ValidationLog` (1:1)

**4. 데이터 모델링 전략 (Focus on Extensibility)**
*   **Generic Detail Storage:** `ProjectDetail` 테이블은 고정된 컬럼 대신, JSONB 타입의 필드(`metadata` 또는 `attributes`)를 포함하도록 설계합니다. 이는 향후 연구과제별로 요구되는 데이터 필드가 유동적일 때, 스키마 변경 없이 유연하게 데이터를 수용할 수 있게 합니다. (JSONB 활용)
*   **Indexing Strategy:** `Institution` 및 `ResearchProject` 테이블에 대해 검색 효율성을 위해 인덱스를 설계합니다. 특히, `Institution.priority_score`는 빠른 필터링이 가능하도록 인덱싱해야 합니다.

**5. 다음 단계 (Developer Action)**
*   이 개념적 모델을 기반으로, 각 테이블별로 **최소 필수 컬럼(Minimum Viable Schema)**을 정의하고, `ProjectDetail` 테이블의 유연성을 확보하기 위한 JSONB 필드 구조를 구체화하겠습니다.
*   이 설계안을 Researcher에게 검토 요청하여, 데이터 추출 요구사항과 스키마 간의 매핑이 일치하는지 확인하겠습니다.