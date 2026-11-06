DROP TABLE IF EXISTS game_saves;
DROP TABLE IF EXISTS scores;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
	id BIGSERIAL PRIMARY KEY,
	username VARCHAR(50) NOT NULL UNIQUE,
	email VARCHAR(255) UNIQUE,
	created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

CREATE INDEX idx_users_username ON users(username);

CREATE TABLE scores (
	id BIGSERIAL PRIMARY KEY,
	user_id BIGINT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
	score INT NOT NULL DEFAULT 0,
	snake_length INT NOT NULL DEFAULT 1,
	duration_interval INTERVAL,
	played_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),

	CONSTRAINT check_positive_score CHECK (score >= 0),
	CONSTRAINT check_positive_length CHECK (snake_length > 0)
);

CREATE INDEX idx_scores_top ON scores(score DESC, played_at DESC);

CREATE TABLE game_saves (
	user_id BIGINT PRIMARY KEY REFERENCES users(id) ON DELETE CASCADE,
	snake_body JSONB NOT NULL,
	apple_pos JSONB NOT NULL,
	direction VARCHAR(5) NOT NULL CONSTRAINT check_dir CHECK (direction  IN ('UP', 'DOWN', 'LEFT', 'RIGHT')),
	current_score INT NOT NULL DEFAULT 0,
	updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
