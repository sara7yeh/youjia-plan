CREATE TABLE `adoption_applications` (
	`id` text PRIMARY KEY NOT NULL,
	`cat_id` text NOT NULL,
	`applicant_id` text NOT NULL,
	`status` text DEFAULT 'submitted' NOT NULL,
	`answers_json` text NOT NULL,
	`contact_viewed_at` text,
	`created_at` text DEFAULT CURRENT_TIMESTAMP NOT NULL,
	`updated_at` text DEFAULT CURRENT_TIMESTAMP NOT NULL,
	FOREIGN KEY (`cat_id`) REFERENCES `cats`(`id`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`applicant_id`) REFERENCES `users`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE UNIQUE INDEX `idx_application_unique` ON `adoption_applications` (`cat_id`,`applicant_id`);--> statement-breakpoint
CREATE INDEX `idx_application_status` ON `adoption_applications` (`status`);--> statement-breakpoint
CREATE TABLE `cat_media` (
	`id` text PRIMARY KEY NOT NULL,
	`cat_id` text NOT NULL,
	`object_key` text NOT NULL,
	`content_type` text NOT NULL,
	`sort_order` integer DEFAULT 0 NOT NULL,
	`is_cover` integer DEFAULT false NOT NULL,
	`created_at` text DEFAULT CURRENT_TIMESTAMP NOT NULL,
	FOREIGN KEY (`cat_id`) REFERENCES `cats`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE INDEX `idx_cat_media_cat` ON `cat_media` (`cat_id`,`sort_order`);--> statement-breakpoint
CREATE TABLE `cats` (
	`id` text PRIMARY KEY NOT NULL,
	`owner_id` text NOT NULL,
	`name` text NOT NULL,
	`sex` text NOT NULL,
	`age_label` text NOT NULL,
	`district` text NOT NULL,
	`story` text NOT NULL,
	`rescue_story` text NOT NULL,
	`vaccine` text DEFAULT 'unknown' NOT NULL,
	`neutered` text DEFAULT 'unknown' NOT NULL,
	`dewormed` text DEFAULT 'unknown' NOT NULL,
	`infectious_test` text DEFAULT 'unknown' NOT NULL,
	`traits_json` text DEFAULT '[]' NOT NULL,
	`match_json` text DEFAULT '[]' NOT NULL,
	`contact_wechat` text,
	`contact_phone` text,
	`handoff` text DEFAULT 'negotiable' NOT NULL,
	`adoption_status` text DEFAULT 'waiting' NOT NULL,
	`submission_status` text DEFAULT 'draft' NOT NULL,
	`adopted_at` text,
	`created_at` text DEFAULT CURRENT_TIMESTAMP NOT NULL,
	`updated_at` text DEFAULT CURRENT_TIMESTAMP NOT NULL,
	FOREIGN KEY (`owner_id`) REFERENCES `users`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE INDEX `idx_cats_public_status` ON `cats` (`submission_status`,`adoption_status`);--> statement-breakpoint
CREATE INDEX `idx_cats_owner` ON `cats` (`owner_id`);--> statement-breakpoint
CREATE TABLE `favorites` (
	`user_id` text NOT NULL,
	`cat_id` text NOT NULL,
	`created_at` text DEFAULT CURRENT_TIMESTAMP NOT NULL,
	FOREIGN KEY (`user_id`) REFERENCES `users`(`id`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`cat_id`) REFERENCES `cats`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE UNIQUE INDEX `idx_favorites_unique` ON `favorites` (`user_id`,`cat_id`);--> statement-breakpoint
CREATE TABLE `follow_ups` (
	`id` text PRIMARY KEY NOT NULL,
	`cat_id` text NOT NULL,
	`application_id` text NOT NULL,
	`due_day` integer NOT NULL,
	`status` text DEFAULT 'pending' NOT NULL,
	`notes` text,
	`media_json` text DEFAULT '[]' NOT NULL,
	`reopen_requested` integer DEFAULT false NOT NULL,
	`completed_at` text,
	`created_at` text DEFAULT CURRENT_TIMESTAMP NOT NULL,
	FOREIGN KEY (`cat_id`) REFERENCES `cats`(`id`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`application_id`) REFERENCES `adoption_applications`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE INDEX `idx_followups_due` ON `follow_ups` (`status`,`due_day`);--> statement-breakpoint
CREATE TABLE `status_history` (
	`id` text PRIMARY KEY NOT NULL,
	`cat_id` text NOT NULL,
	`actor_id` text NOT NULL,
	`from_status` text,
	`to_status` text NOT NULL,
	`note` text,
	`created_at` text DEFAULT CURRENT_TIMESTAMP NOT NULL,
	FOREIGN KEY (`cat_id`) REFERENCES `cats`(`id`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`actor_id`) REFERENCES `users`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE INDEX `idx_status_history_cat` ON `status_history` (`cat_id`,`created_at`);--> statement-breakpoint
CREATE TABLE `submission_reviews` (
	`id` text PRIMARY KEY NOT NULL,
	`cat_id` text NOT NULL,
	`reviewer_id` text NOT NULL,
	`result` text NOT NULL,
	`reason` text,
	`created_at` text DEFAULT CURRENT_TIMESTAMP NOT NULL,
	FOREIGN KEY (`cat_id`) REFERENCES `cats`(`id`) ON UPDATE no action ON DELETE no action,
	FOREIGN KEY (`reviewer_id`) REFERENCES `users`(`id`) ON UPDATE no action ON DELETE no action
);
--> statement-breakpoint
CREATE INDEX `idx_reviews_cat` ON `submission_reviews` (`cat_id`);--> statement-breakpoint
CREATE TABLE `users` (
	`id` text PRIMARY KEY NOT NULL,
	`phone` text NOT NULL,
	`wechat_open_id` text,
	`display_name` text DEFAULT '' NOT NULL,
	`role` text DEFAULT 'adopter' NOT NULL,
	`district` text,
	`created_at` text DEFAULT CURRENT_TIMESTAMP NOT NULL
);
--> statement-breakpoint
CREATE UNIQUE INDEX `idx_users_phone` ON `users` (`phone`);--> statement-breakpoint
CREATE UNIQUE INDEX `idx_users_wechat` ON `users` (`wechat_open_id`);