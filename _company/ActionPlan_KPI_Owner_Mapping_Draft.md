# Action Plan: KPI 매핑 구조 및 단계별 책임(Owner) 명세서 (Draft v1.0)

## 1. 문서 개요
본 문서는 최종 확정된 Action Plan의 각 실행 단계(Task)와 이에 대응하는 핵심 성과 지표(KPI), 그리고 해당 단계를 책임질 담당자(Owner)를 명확히 정의하여 개발팀 및 이해관계자에게 전달하기 위해 작성되었습니다.

## 2. KPI 매핑 구조 정의
| 단계 (Phase/Module) | 세부 Task (Task Description) | 핵심 성과 지표 (KPI) | 측정 기준 (Metric Definition) | 목표치 (Target) | KPI 연관성 (Weight %) | 최종 검토자 (Reviewer) |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **Phase 1: 데이터 인프라 구축** | DB/API 스키마 최종 확정 및 설계 반영 | Schema Accuracy Rate | 설계서와 실제 DB/API 스키마 간의 불일치율 (%) | 0% | 25% | Researcher |
| | 데이터 추출 SOP 최종 승인 | SOP Completeness Score | 정의된 모든 데이터 수집 단계의 포함 여부 (%) | 100% | 25% | Researcher |
| **Phase 2: 핵심 로직 개발** | Core Algorithm V1.0 구현 | Algorithm Performance (Latency) | 평균 응답 시간 (ms) | 200ms 이하 | 30% | 코다리 |
| | AMS 가중치 적용 로직 통합 | Feature Integration Success Rate | 기능 테스트 통과율 (%) | 95% 이상 | 20% | 코다리 |
| **Phase 3: 시스템 통합 및 테스트** | End-to-End Integration Test | Defect Density (Bug Count) | 발견된 심각도 높은 버그 수/테스트 케이스 수 | 1/10 이상 | 15% | 코다리 |
| | 병목 해결 (Mitigation Plan) 구현 | Risk Reduction Score | 식별된 주요 병목 지점의 해결률 (%) | 80% 이상 | 10% | 코다리 |
| **Phase 4: 배포 준비** | 개발팀 전달 문서 최종 검토 | Handoff Document Compliance | 요구사항 대비 명세서 정확도 (%) | 100% | 5% | Researcher / Business |

## 3. 단계별 책임(Owner) 명세
| Phase/Module | 주요 Task 그룹 | Primary Owner (책임자) | Secondary Reviewer (검토자) | 비고 (Notes) |
| :--- | :--- | :--- | :--- | :--- |
| Phase 1: 데이터 인프라 구축 | 스키마 설계 및 데이터 추출 정의 | Researcher | Developer (코다리) | 데이터 구조의 정확성 확보가 최우선. |
| Phase 2: 핵심 로직 개발 | 알고리즘 구현 및 가중치 통합 | 코다리 | Researcher | 기술적 구현 가능성 검증 필수. |
| Phase 3: 시스템 통합 및 테스트 | 통합 테스트 및 안정성 확보 | 코다리 | Business | 실제 환경에서의 성능 검증에 집중. |
| Phase 4: 배포 준비 | 최종 문서화 및 검토 | Researcher | Business | 개발팀 전달 용이성 확보. |

## 4. 향후 조치
- **검토 요청:** 코다리에게 위 KPI 매핑 구조에 대해 기술적 관점(특히 Weight % 분배)의 피드백을 요청합니다.
- **최종 확정:** 코다리의 기술 검토 결과를 반영하여 KPI와 Owner를 최종 조정합니다.

*작성일: 2026-06-07*