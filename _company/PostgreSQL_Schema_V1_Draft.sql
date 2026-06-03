-- PostgreSQL DB 스키마 V1 (초안)

-- 테이블 설계: 연구과제 데이터 모델링
CREATE TABLE IF NOT EXISTS research_projects (
    project_id SERIAL PRIMARY KEY,
    project_code VARCHAR(50) UNIQUE NOT NULL, -- 연구과제 고유 코드
    project_name VARCHAR(255) NOT NULL,      -- 연구과제명
    target_agency_id INT NOT NULL,            -- 타겟 기관 ID (FK to agencies table)
    submission_date DATE NOT NULL,           -- 제출일
    status VARCHAR(50) NOT NULL DEFAULT 'Pending', -- 상태 (e.g., Pending, Accepted, Rejected)
    ams_score DECIMAL(5, 2),                 -- ALTIT 매칭 점수 (AMS)
    required_data_set JSONB,                 -- Researcher가 정의한 핵심 데이터 항목 (Schema V1.0 반영)
    extracted_data_path VARCHAR(255),        -- 추출된 데이터의 저장 경로
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 테이블 설계: 데이터 추출 로그 및 메타데이터 관리
CREATE TABLE IF NOT EXISTS extraction_logs (
    log_id SERIAL PRIMARY KEY,
    project_id INT REFERENCES research_projects(project_id) ON DELETE CASCADE,
    extraction_step VARCHAR(100) NOT NULL, -- 추출 단계 (e.g., Step1_SourceFetch, Step2_DataParsing, Step3_Validation)
    start_time TIMESTAMP WITH TIME ZONE NOT NULL,
    end_time TIMESTAMP WITH TIME ZONE,
    status VARCHAR(50) NOT NULL, -- Status (Success, Failure, InProgress)
    error_details TEXT,             -- 오류 발생 시 상세 내용
    source_api VARCHAR(100)          -- 사용된 API 또는 크롤러 소스
);

-- 테이블 설계: AMS 가중치 설정 (KPI 프레임워크 연동)
CREATE TABLE IF NOT EXISTS ams_weights (
    weight_id SERIAL PRIMARY KEY,
    metric_name VARCHAR(100) UNIQUE NOT NULL, -- 측정 지표 이름 (e.g., 'RelevanceScore', 'FundingPotential')
    weight_value DECIMAL(5, 2) NOT NULL,      -- 가중치 값 (0.0 ~ 1.0)
    description TEXT,
    is_active BOOLEAN DEFAULT TRUE
);

-- 초기 데이터 삽입 예시 (테스트용)
INSERT INTO ams_weights (metric_name, weight_value, description) VALUES 
('RelevanceScore', 0.45, '연구 주제의 시의성과 트렌드 반영도'),
('FundingPotential', 0.35, '해당 기관의 재정적 지원 가능성'),
('AlignmentWithMission', 0.20, '회사 미션과의 전반적 정렬도');

-- 초기 데이터 삽입 예시 (테스트용)
INSERT INTO research_projects (project_code, project_name, target_agency_id, submission_date, status, ams_score, required_data_set, extracted_data_path) VALUES
('R2024001', 'AI 기반 의료 진단 기술 연구', 1, '2026-07-01', 'Pending', NULL, '{"data_set": ["tech_spec", "budget_req", "target_keywords"]}', NULL);

COMMIT;