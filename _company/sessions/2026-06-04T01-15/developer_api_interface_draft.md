<content># DB 스키마 V1 및 API 인터페이스 초안 설계 (Phase 2) - 최종 산출물 - 최종 산출물

## 1. DB 스키마 V1 상세 확장 (Schema Refinement)

Researcher가 정의한 데이터 항목(최소 13개 컬럼 기준)을 기반으로, 엔티티 간의 관계(Foreign Key 설정 포함)를 명확히 하는 최종 스키마 구조를 확정합니다. 데이터 정제(Refinement) 단계에서 필요한 상태(Status), 출처(Source ID), 버전 관리 필드를 추가하여 데이터의 추적 가능성을 높입니다.

### 1.1 핵심 엔티티 정의 (Core Entities)

| 엔티티 명 | 주요 역할 | 주요 필드 (핵심 속성) | 관계 (FK/R) | 비고 |
| :--- | :--- | :--- | :--- | :--- |
| **ResearchProject** (연구과제) | 최종 결과물이 저장되는 핵심 엔티티. | `project_id` (PK), `title`, `abstract`, `status` (Active/Pending/Archived), `source_institution_id` (FK), `extracted_at`, `version` | R: SourceInstitution | 데이터의 최종 상태 관리. |
| **SourceInstitution** (기관 정보) | 데이터를 수집한 출처 기관 정보를 관리. | `institution_id` (PK), `name`, `domain`, `access_level`, `api_key_config` | R: ResearchProject | 기관별 접근 권한 및 메타데이터 관리. |
| **ExtractedDataLog** (추출 로그) | 원시 데이터의 무결성을 보장하고 추적하는 로그. | `log_id` (PK), `project_id` (FK), `source_institution_id` (FK), `raw_data_json`, `mapping_status`, `validation_errors` | R: ResearchProject, SourceInstitution | 데이터 수집의 투명성을 확보. |
| **DataMapping** (매핑 정보) | 정제 단계에서 데이터가 스키마에 매핑되는 상세 규칙을 저장. | `mapping_id` (PK), `log_id` (FK), `target_field`, `source_field`, `transformation_logic` (JSON/String), `validation_rule` | R: ExtractedDataLog | 데이터 변환 로직의 유연성 확보. |

### 1.2 필수 컬럼 확장 (필요 데이터 항목 반영)

*   **ResearchProject:** `status` 필드 추가. (Researcher SOP 단계 1단계: 수집 완료 시점에 'Pending Review' 상태로 초기화)
*   **ExtractedDataLog:** `validation_errors` 필드 추가. (Researcher SOP 단계 2: 정제 과정에서 발생하는 오류 코드를 기록)

## 2. API 인터페이스 설계 (Interface Definition Draft)

Phase 1.1에서 확정된 '타겟 기관별 접근 경로'를 기반으로, 각 데이터 수집 단계(1.2)에서 호출될 가상의 API 엔드포인트 및 예상되는 요청/응답 스키마를 정의합니다.

### 2.1 API 엔드포인트 구조 예시 (Conceptual Endpoints)

| 단계 | 목적 | 가상 Endpoint 경로 | HTTP Method | 필요한 인증/키 |
| :--- | :--- | :--- | :--- | :--- |
| **1.1 (Discovery)** | 기관별 데이터 리스트 요청 | `/api/v1/institutions/{institution_id}/projects` | GET | Institution API Key |
| **1.2 (Extraction)** | 특정 연구과제 상세 데이터 요청 | `/api/v1/institution/{id}/data/{project_id}` | GET | Institution API Key, Project Token |
| **1.3 (Validation)** | 수집된 데이터 품질 검증 요청 | `/api/v1/validation/check` | POST | Internal Validation Token |

### 2.2 데이터 추출 시나리오 매핑 (Extraction Scenario Mapping)

**목표:** Researcher의 `Extraction_Scenario_Drafts`에서 도출된 특정 데이터 항목이 위 API 호출 시 어떤 구조로 반환될지 정의합니다.

*   **예시 (기관 A, 프로젝트 X):**
    *   **API 호출:** `/api/v1/institution/A/data/X` (GET)
    *   **예상 응답 구조:** `{ "metadata": {...}, "results": [ { "title": "...", "funding_source": "...", "keywords": [...] } ] }`
    *   **매핑 전략:** `results[].title` $\rightarrow$ `ResearchProject.title`, `results[].funding_source` $\rightarrow$ `ResearchProject.funding_source`.

## 3. 매핑 로직 초안 (Mapping Logic Draft)

DataMapping 엔티티는 데이터 변환의 유연성을 확보하기 위해 **Declarative** 방식으로 설계되어야 합니다.

*   **핵심 원칙:** 데이터의 **출처(Source)**와 **목적지(Target)**를 명확히 분리하고, 변환 로직은 필요 시 별도의 서비스 레이어에서 실행되도록 설계합니다.
*   **초안 구조:** `transformation_logic` 필드에 JSON 형태로 변환 규칙을 저장합니다.
    *   **JSON 예시:** `{"source_field": "raw_data.title", "target_field": "ResearchProject.title", "transform_type": "STRING_MAP", "notes": "Trim whitespace and normalize case."}`

</content>