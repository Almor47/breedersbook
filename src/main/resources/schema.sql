CREATE TABLE IF NOT EXISTS user_info (
	id 			BIGINT GENERATED BY DEFAULT AS IDENTITY 										NOT NULL,
	description		VARCHAR(5000),
	address 		VARCHAR(1000),
	phone_number		VARCHAR(20),
	birth_date	 	TIMESTAMP 				WITHOUT TIME ZONE CHECK (birth_date < CURRENT_DATE) 				NOT NULL,
	created		 	TIMESTAMP 				WITHOUT TIME ZONE DEFAULT NOW() 						NOT NULL,
	photo_url	   	VARCHAR(250),

	CONSTRAINT pk_user_info PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS kennels (
	id 			BIGINT GENERATED BY DEFAULT AS IDENTITY 										NOT NULL,
	name 			VARCHAR(250) 														NOT NULL,
	description		VARCHAR(5000)														NOT NULL,
	address 		VARCHAR(1000)														NOT NULL,
	phone_number		VARCHAR(20)														NOT NULL,
	lat			FLOAT(10)														NOT NULL,
	lon			FLOAT(10)														NOT NULL,
	created		 	TIMESTAMP 				WITHOUT TIME ZONE DEFAULT NOW() 						NOT NULL,
	photo_url	   	VARCHAR(250),

	CONSTRAINT pk_kennels PRIMARY KEY (id),
	CONSTRAINT uq_kennels UNIQUE (name),
	CONSTRAINT uq_kennels UNIQUE (address)
);

CREATE TABLE IF NOT EXISTS users (
	id 			BIGINT GENERATED BY DEFAULT AS IDENTITY		 									NOT NULL,
	name 			VARCHAR(250) 														NOT NULL,
	login 			VARCHAR(250) 														NOT NULL,
	email 			VARCHAR(40) 				CHECK (email <> '')								NOT NULL,
	role			VARCHAR(50) 														NOT NULL,

	user_info_id		BIGINT					 										NOT NULL,
	kennel_id 		BIGINT,

	CONSTRAINT fk_user_info_id FOREIGN KEY (user_info_id) REFERENCES user_info (id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT fk_kennel_id FOREIGN KEY (kennel_id) REFERENCES kennels (id),

	CONSTRAINT pk_users PRIMARY KEY (id),
	CONSTRAINT uq_users UNIQUE (email),
	CONSTRAINT uq_users UNIQUE (login)
);

CREATE TABLE IF NOT EXISTS breeds (
	id 			BIGINT GENERATED BY DEFAULT AS IDENTITY 										NOT NULL,
	name 			VARCHAR(250) 														NOT NULL,
	description		VARCHAR(5000)														NOT NULL,
	photo_url	   	VARCHAR(250),

	CONSTRAINT pk_breeds PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS pets (
	id	 		BIGINT GENERATED BY DEFAULT AS IDENTITY 										NOT NULL,
	type			VARCHAR(50) 														NOT NULL,
	sex 			BOOLEAN		 													NOT NULL,
	color			VARCHAR(50) 														NOT NULL,
	temper			VARCHAR(2000),
	description		VARCHAR(5000),
	name 			VARCHAR(250),
	birth_date	 	TIMESTAMP 				WITHOUT TIME ZONE CHECK (birth_date < CURRENT_DATE) 				NOT NULL,
	death_date	 	TIMESTAMP				WITHOUT TIME ZONE,
	price			INTEGER,
	sale_status		VARCHAR(20) 														NOT NULL,
	sale_date		TIMESTAMP 				WITHOUT TIME ZONE CHECK (birth_date < CURRENT_DATE),
	passport_img   		VARCHAR(50),
	sterilization		BOOLEAN  				DEFAULT FALSE									NOT NULL,

	kennel_id		BIGINT		 													NOT NULL,
	owner_id		BIGINT		 													NOT NULL,
	breed_id 		BIGINT		 													NOT NULL,

	CONSTRAINT pk_pets PRIMARY KEY (id),
	CONSTRAINT uq_pets UNIQUE (passport_img),

	CONSTRAINT fk_kennel_id FOREIGN KEY (kennel_id) REFERENCES kennelS (id),
	CONSTRAINT fk_owner_id FOREIGN KEY (owner_id) REFERENCES users (id),
	CONSTRAINT fk_breed_id FOREIGN KEY (breed_id) REFERENCES breeds (id)
);

CREATE TABLE IF NOT EXISTS awards (
	id 			BIGINT GENERATED BY DEFAULT AS IDENTITY 										NOT NULL,
	name 			VARCHAR(250) 														NOT NULL,
	description		VARCHAR(5000)														NOT NULL,
	photo_url	   	VARCHAR(250),

	CONSTRAINT pk_awards PRIMARY KEY (id),
	CONSTRAINT uq_awards UNIQUE (name)
);

CREATE TABLE IF NOT EXISTS disease (
	id 			BIGINT GENERATED BY DEFAULT AS IDENTITY 										NOT NULL,
	name 			VARCHAR(250) 														NOT NULL,
	description		VARCHAR(5000)														NOT NULL,
	chronic		   	BOOLEAN 				DEFAULT FALSE									NOT NULL,

	CONSTRAINT pk_disease PRIMARY KEY (id),
	CONSTRAINT uq_disease UNIQUE (name)
);

CREATE TABLE IF NOT EXISTS surgeries (
	id 			BIGINT GENERATED BY DEFAULT AS IDENTITY 										NOT NULL,
	name 			VARCHAR(250) 														NOT NULL,
	description		VARCHAR(5000)														NOT NULL,
	type		   	VARCHAR(250)														NOT NULL,

	CONSTRAINT pk_surgeries PRIMARY KEY (id),
	CONSTRAINT uq_surgeries UNIQUE (name)
);

CREATE TABLE IF NOT EXISTS vacs (
	id 			BIGINT GENERATED BY DEFAULT AS IDENTITY 										NOT NULL,
	name 			VARCHAR(250) 														NOT NULL,
	type		   	VARCHAR(50)														NOT NULL,

	CONSTRAINT pk_vacs PRIMARY KEY (id),
	CONSTRAINT uq_vacs UNIQUE (name)
);

CREATE TABLE IF NOT EXISTS news (
	id	 		BIGINT GENERATED BY DEFAULT AS IDENTITY 										NOT NULL,
	text_news		VARCHAR(5000) 														NOT NULL,
	news_date	 	TIMESTAMP 				WITHOUT TIME ZONE 								NOT NULL,
	likes		   	BIGINT					DEFAULT 0									NOT NULL,
	views		   	BIGINT					DEFAULT 0									NOT NULL,

	kennel_id		BIGINT		 													NOT NULL,

	CONSTRAINT pk_news PRIMARY KEY (id),

	CONSTRAINT fk_kennel_id FOREIGN KEY (kennel_id) REFERENCES kennelS (id)
);

CREATE TABLE IF NOT EXISTS message (
	id	 		BIGINT GENERATED BY DEFAULT AS IDENTITY 										NOT NULL,
	text_message		VARCHAR(2000) 														NOT NULL,
	message_date		TIMESTAMP 				WITHOUT TIME ZONE 								NOT NULL,

	user_one_id		BIGINT		 													NOT NULL,
	user_two_id		BIGINT		 													NOT NULL,

	CONSTRAINT pk_message PRIMARY KEY (id),

	CONSTRAINT fk_user_one_id FOREIGN KEY (user_one_id) REFERENCES users (id),
	CONSTRAINT fk_user_two_id FOREIGN KEY (user_two_id) REFERENCES users (id)
);

CREATE TABLE IF NOT EXISTS users_pets (

	user_id			BIGINT	 														NOT NULL,
	pet_id			BIGINT	 														NOT NULL,

	CONSTRAINT fk_users_pets_to_users FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE,
	CONSTRAINT fk_users_pets_to_pets FOREIGN KEY (pet_id) REFERENCES pets (id) ON DELETE CASCADE,

	PRIMARY KEY (user_id, pet_id)
);

CREATE TABLE IF NOT EXISTS parents (

	pet_id			BIGINT	 														NOT NULL,
	mother_id		BIGINT															NOT NULL,
	father_id		BIGINT		 													NOT NULL,

	CONSTRAINT fk_parents_to_pets FOREIGN KEY (pet_id) REFERENCES pets (id) ON DELETE CASCADE,
	CONSTRAINT fk_parents_to_mothers FOREIGN KEY (mother_id) REFERENCES users (id) ON DELETE CASCADE,
	CONSTRAINT fk_parents_to_fathers FOREIGN KEY (father_id) REFERENCES users (id) ON DELETE CASCADE,

	PRIMARY KEY (pet_id, mother_id, father_id)
);

CREATE TABLE IF NOT EXISTS pets_awards (

	pet_id			BIGINT	 														NOT NULL,
	award_id		BIGINT	 														NOT NULL,

	CONSTRAINT fk_pets_awards_to_pets FOREIGN KEY (pet_id) REFERENCES pets (id) ON DELETE CASCADE,
	CONSTRAINT fk_pets_awards_to_awards FOREIGN KEY (award_id) REFERENCES awards (id) ON DELETE CASCADE,

	PRIMARY KEY (pet_id, award_id)
);

CREATE TABLE IF NOT EXISTS pets_disease (

	pet_id			BIGINT		 													NOT NULL,
	disease_id		BIGINT		 													NOT NULL,

	CONSTRAINT fk_pets_disease_to_pets FOREIGN KEY (pet_id) REFERENCES pets (id) ON DELETE CASCADE,
	CONSTRAINT fk_pets_disease_to_diseases FOREIGN KEY (disease_id) REFERENCES disease (id) ON DELETE CASCADE,

	PRIMARY KEY (pet_id, disease_id)
);

CREATE TABLE IF NOT EXISTS pets_surgeries (

	pet_id			BIGINT					 										NOT NULL,
	operation_id		BIGINT		 													NOT NULL,

	CONSTRAINT fk_pets_surgeries_to_pets FOREIGN KEY (pet_id) REFERENCES pets (id) ON DELETE CASCADE,
	CONSTRAINT fk_pets_surgeries_to_surgeries FOREIGN KEY (operation_id) REFERENCES surgeries (id) ON DELETE CASCADE,

	PRIMARY KEY (pet_id, operation_id)
);

CREATE TABLE IF NOT EXISTS pets_vacs (

	pet_id			BIGINT															NOT NULL,
	vac_id			BIGINT															NOT NULL,

	CONSTRAINT fk_pets_vacs_to_pets FOREIGN KEY (pet_id) REFERENCES pets (id) ON DELETE CASCADE,
	CONSTRAINT fk_pets_vacs_to_vacs FOREIGN KEY (vac_id) REFERENCES vacs (id) ON DELETE CASCADE,

	PRIMARY KEY (pet_id, vac_id)
);