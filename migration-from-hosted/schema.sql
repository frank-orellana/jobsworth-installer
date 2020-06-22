/*  
This file is part of the jobsworth-installer program
https://github.com/frank-orellana/jobsworth-installer

Copyright (C) 2017  Franklin Orellana

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software Foundation,
Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301  USA

WARNING:
-This file will create a Database if it not exist named clockingit.
-If the database already exists you might lose your information
*/

create database if not exists clockingit  CHARACTER SET utf8 COLLATE utf8_unicode_ci;
use clockingit;

Drop Table If Exists `activities`;
CREATE TABLE `activities` (
    `id` int(11),
    `user_id` int(11),
    `company_id` int(11),
    `customer_id` int(11),
    `project_id` int(11),
    `activity_type` int(11),
    `body` varchar(255),
    `created_at` datetime,
  PRIMARY KEY  (`id`)
) DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

Drop Table If Exists `chat_messages`;
CREATE TABLE `chat_messages` (
    `id` int(11),
    `chat_id` int(11),
    `user_id` int(11),
    `body` varchar(255),
    `created_at` datetime,
    `updated_at` datetime,
    `archived` int(1),
  PRIMARY KEY  (`id`)
) DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

Drop Table If Exists `chats`;
CREATE TABLE `chats` (
    `id` int(11),
    `user_id` int(11),
    `target_id` int(11),
    `active` int(11),
    `position` int(11),
    `last_seen` int(11),
    `created_at` datetime,
    `updated_at` datetime,
  PRIMARY KEY  (`id`)
) DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

Drop Table If Exists `companies`;
CREATE TABLE `companies` (
    `id` int(11),
    `name` varchar(255),
    `contact_email` varchar(255),
    `contact_name` varchar(255),
    `created_at` datetime,
    `updated_at` datetime,
    `subdomain` varchar(255),
    `show_wiki` int(1),
    `show_forum` int(1),
    `show_chat` int(1),
    `show_messaging` int(1),
    `restricted_userlist` int(1),
    `tmp_1` datetime,
  PRIMARY KEY  (`id`)
) DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

Drop Table If Exists `customers`;
CREATE TABLE `customers` (
    `id` int(11),
    `company_id` int(11),
    `name` varchar(255),
    `contact_email` varchar(255),
    `contact_name` varchar(255),
    `created_at` datetime,
    `updated_at` datetime,
    `css` text,
    `binary_id` int(11),
  PRIMARY KEY  (`id`)
) DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

Drop Table If Exists `dependencies`;
CREATE TABLE `dependencies` (
    `id` int(11),
    `task_id` int(11),
    /*`dependency_id` int(11), The dump only throws two columns for this table */
  PRIMARY KEY  (`id`,`task_id`)
) DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

Drop Table If Exists `emails`;
CREATE TABLE `emails` (
    `id` int(11),
    `from` varchar(255),
    `to` varchar(255),
    `subject` varchar(255),
    `body` text,
    `company_id` int(11),
    `user_id` int(11),
    `created_at` datetime,
    `updated_at` datetime,
  PRIMARY KEY  (`id`)
) DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

Drop Table If Exists `event_logs`;
CREATE TABLE `event_logs` (
    `id` int(11),
    `company_id` int(11),
    `project_id` int(11),
    `user_id` int(11),
    `event_type` int(11),
    `target_type` varchar(255),
    `target_id` int(11),
    `title` varchar(255),
    `body` text,
    `created_at` datetime,
    `updated_at` datetime,
    `user` varchar(255),
  PRIMARY KEY  (`id`)
) DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

Drop Table If Exists `forums`;
CREATE TABLE `forums` (
    `id` int(11),
    `company_id` int(11),
    `project_id` int(11),
    `name` varchar(255),
    `description` varchar(255),
    `topics_count` int(11),
    `posts_count` int(11),
    `position` int(11),
    `description_html` text,
  PRIMARY KEY  (`id`)
) DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

Drop Table If Exists `generated_reports`;
CREATE TABLE `generated_reports` (
    `id` int(11),
    `company_id` int(11),
    `user_id` int(11),
    `filename` varchar(255),
    `report` text,
    `created_at` datetime,
  PRIMARY KEY  (`id`)
) DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

Drop Table If Exists `ical_entries`;
CREATE TABLE `ical_entries` (
    `id` int(11),
    `task_id` int(11),
    `work_log_id` int(11),
    `body` text,
  PRIMARY KEY  (`id`)
) DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

Drop Table If Exists `locales`;
CREATE TABLE `locales` (
    `id` int(11),
    `locale` varchar(255),
    `key` varchar(255),
    `singular` text,
    `plural` text,
    `user_id` int(11),
    `created_at` datetime,
    `updated_at` datetime,
    `same` int(1),
  PRIMARY KEY  (`id`)
) DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

Drop Table If Exists `logged_exceptions`;
CREATE TABLE `logged_exceptions` (
    `id` int(11),
    `exception_class` varchar(255),
    `controller_name` varchar(255),
    `action_name` varchar(255),
    `message` varchar(255),
    `backtrace` text,
    `environment` text,
    `request` text,
    `created_at` datetime,
  PRIMARY KEY  (`id`)
) DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

Drop Table If Exists `milestones`;
CREATE TABLE `milestones` (
    `id` int(11),
    `company_id` int(11),
    `project_id` int(11),
    `user_id` int(11),
    `name` varchar(255),
    `description` text,
    `due_at` datetime,
    `position` int(11),
    `completed_at` datetime,
    `total_tasks` int(11),
    `completed_tasks` int(11),
    `scheduled_at` datetime,
    `scheduled` int(1),
  PRIMARY KEY  (`id`)
) DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

Drop Table If Exists `moderatorships`;
CREATE TABLE `moderatorships` (
    `id` int(11),
    `forum_id` int(11),
    `user_id` int(11),
  PRIMARY KEY  (`id`)
) DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

Drop Table If Exists `monitorships`;
CREATE TABLE `monitorships` (
    `id` int(11),
    `monitorship_id` int(11),
    `user_id` int(11),
    `active` int(1),
    `monitorship_type` varchar(255),
  PRIMARY KEY  (`id`)
) DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

Drop Table If Exists `news_items`;
CREATE TABLE `news_items` (
    `id` int(11),
    `created_at` datetime,
    `body` text,
    `portal` int(1),
  PRIMARY KEY  (`id`)
) DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

Drop Table If Exists `notifications`;
CREATE TABLE `notifications` (
    `id` int(11),
    `task_id` int(11),
    `user_id` int(11),
  PRIMARY KEY  (`id`)
) DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

Drop Table If Exists `pages`;
CREATE TABLE `pages` (
    `id` int(11),
    `name` varchar(255),
    `body` text,
    `company_id` int(11),
    `user_id` int(11),
    `project_id` int(11),
    `created_at` datetime,
    `updated_at` datetime,
    `position` int(11),
  PRIMARY KEY  (`id`)
) DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

Drop Table If Exists `posts`;
CREATE TABLE `posts` (
    `id` int(11),
    `user_id` int(11),
    `topic_id` int(11),
    `body` text,
    `created_at` datetime,
    `updated_at` datetime,
    `forum_id` int(11),
    `body_html` text,
  PRIMARY KEY  (`id`)
) DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

Drop Table If Exists `project_files`;
CREATE TABLE `project_files` (
    `id` int(11),
    `company_id` int(11),
    `project_id` int(11),
    `customer_id` int(11),
    `name` varchar(255),
    `binary_id` int(11),
    `file_type` int(11),
    `created_at` datetime,
    `updated_at` datetime,
    `filename` varchar(255),
    `thumbnail_id` int(11),
    `file_size` int(11),
    `task_id` int(11),
    `mime_type` varchar(255),
    `project_folder_id` int(11),
    `user_id` int(11),
  PRIMARY KEY  (`id`)
) DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

Drop Table If Exists `project_folders`;
CREATE TABLE `project_folders` (
    `id` int(11),
    `name` varchar(255),
    `project_id` int(11),
    `parent_id` int(11),
    `created_at` datetime,
    `company_id` int(11),
  PRIMARY KEY  (`id`)
) DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

Drop Table If Exists `project_permissions`;
CREATE TABLE `project_permissions` (
    `id` int(11),
    `company_id` int(11),
    `project_id` int(11),
    `user_id` int(11),
    `created_at` datetime,
    `can_comment` int(1),
    `can_work` int(1),
    `can_report` int(1),
    `can_create` int(1),
    `can_edit` int(1),
    `can_reassign` int(1),
    `can_prioritize` int(1),
    `can_close` int(1),
    `can_grant` int(1),
    `can_milestone` int(1),
  PRIMARY KEY  (`id`)
) DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

Drop Table If Exists `projects`;
CREATE TABLE `projects` (
    `id` int(11),
    `name` varchar(255),
    `user_id` int(11),
    `company_id` int(11),
    `customer_id` int(11),
    `created_at` datetime,
    `updated_at` datetime,
    `completed_at` datetime,
    `critical_count` int(11),
    `normal_count` int(11),
    `low_count` int(11),
    `description` text,
    `create_forum` int(1),
    `tmp_1` int(11),
    `tmp_2` int(11),
    `tmp_3` int(11),
    `tmp_4` int(11),
  PRIMARY KEY  (`id`)
) DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

Drop Table If Exists `scm_changesets`;
CREATE TABLE `scm_changesets` (
    `id` int(11),
    `company_id` int(11),
    `project_id` int(11),
    `user_id` int(11),
    `scm_project_id` int(11),
    `author` varchar(255),
    `changeset_num` int(11),
    `commit_date` datetime,
    `changeset_rev` varchar(255),
    `message` text,
  PRIMARY KEY  (`id`)
) DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

Drop Table If Exists `scm_files`;
CREATE TABLE `scm_files` (
    `id` int(11),
    `project_id` int(11),
    `company_id` int(11),
    `name` text,
    `path` text,
    `state` varchar(255),
    `commit_date` datetime,
  PRIMARY KEY  (`id`)
) DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

Drop Table If Exists `scm_projects`;
CREATE TABLE `scm_projects` (
    `id` int(11),
    `project_id` int(11),
    `company_id` int(11),
    `scm_type` varchar(255),
    `last_commit_date` datetime,
    `last_update` datetime,
    `last_checkout` datetime,
    `module` text,
    `location` text,
  PRIMARY KEY  (`id`)
) DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

Drop Table If Exists `scm_revisions`;
CREATE TABLE `scm_revisions` (
    `id` int(11),
    `company_id` int(11),
    `project_id` int(11),
    `user_id` int(11),
    `scm_changeset_id` int(11),
    `scm_file_id` int(11),
    `revision` varchar(255),
    `author` varchar(255),
    `commit_date` datetime,
    `state` varchar(255),
  PRIMARY KEY  (`id`)
) DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

Drop Table If Exists `sessions`;
CREATE TABLE `sessions` (
    `id` int(11),
    `session_id` varchar(255),
    `data` text,
    `updated_at` datetime,
  PRIMARY KEY  (`id`)
) DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

Drop Table If Exists `sheets`;
CREATE TABLE `sheets` (
    `id` int(11),
    `user_id` int(11),
    `task_id` int(11),
    `project_id` int(11),
    `created_at` datetime,
    `body` text,
    `paused_at` datetime,
    `paused_duration` int(11),
  PRIMARY KEY  (`id`)
) DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

Drop Table If Exists `shout_channel_subscriptions`;
CREATE TABLE `shout_channel_subscriptions` (
    `id` int(11),
    `shout_channel_id` int(11),
    `user_id` int(11),
  PRIMARY KEY  (`id`)
) DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

Drop Table If Exists `shout_channels`;
CREATE TABLE `shout_channels` (
    `id` int(11),
    `company_id` int(11),
    `project_id` int(11),
    `name` varchar(255),
    `description` text,
    `public` int(11),
  PRIMARY KEY  (`id`)
) DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

Drop Table If Exists `shouts`;
CREATE TABLE `shouts` (
    `id` int(11),
    `company_id` int(11),
    `user_id` int(11),
    `created_at` datetime,
    `body` text,
    `shout_channel_id` int(11),
    `message_type` int(11),
    `nick` varchar(255),
  PRIMARY KEY  (`id`)
) DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

Drop Table If Exists `task_tags`;
CREATE TABLE `task_tags` (
    `tag_id` int(11),
    `task_id` int(11),
  PRIMARY KEY  (`tag_id`,`task_id`)
) DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

Drop Table If Exists `task_owners`;
CREATE TABLE `task_owners` (
    `id` int(11),
    `user_id` int(11),
    `task_id` int(11),
  PRIMARY KEY  (`id`)
) DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

Drop Table If Exists `task_tags`;
CREATE TABLE `task_tags` (
    `id` int(11),
    `tag_id` int(11),
    `task_id` int(11),
  PRIMARY KEY  (`id`)
) DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

Drop Table If Exists `tasks`;
CREATE TABLE `tasks` (
    `id` int(11),
    `name` varchar(255),
    `project_id` int(11),
    `position` int(11),
    `created_at` datetime,
    `due_at` datetime,
    `updated_at` datetime,
    `completed_at` datetime,
    `duration` int(11),
    `hidden` int(11),
    `milestone_id` int(11),
    `description` text,
    `company_id` int(11),
    `priority` int(11),
    `updated_by_id` int(11),
    `severity_id` int(11),
    `type_id` int(11),
    `task_num` int(11),
    `status` int(11),
    `requested_by` varchar(255),
    `creator_id` int(11),
    `notify_emails` varchar(255),
    `repeat` varchar(255),
    `hide_until` datetime,
    `scheduled_at` datetime,
    `scheduled_duration` int(11),
    `scheduled` int(1),
    `tmp_1` int(11),
  PRIMARY KEY  (`id`)
) DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

Drop Table If Exists `todos`;
CREATE TABLE `todos` (
    `id` int(11),
    `task_id` int(11),
    `name` varchar(255),
    `position` int(11),
    `creator_id` int(11),
    `completed_at` datetime,
    `created_at` datetime,
    `updated_at` datetime,
    `tmp_1` int(11),
  PRIMARY KEY  (`id`)
) DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

Drop Table If Exists `topics`;
CREATE TABLE `topics` (
    `id` int(11),
    `forum_id` int(11),
    `user_id` int(11),
    `title` varchar(255),
    `created_at` datetime,
    `updated_at` datetime,
    `hits` int(11),
    `sticky` int(11),
    `posts_count` int(11),
    `replied_at` datetime,
    `locked` int(1),
    `replied_by` int(11),
    `last_post_id` int(11),
  PRIMARY KEY  (`id`)
) DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

Drop Table If Exists `users`;
CREATE TABLE `users` (
    `id` int(11),
    `name` varchar(255),
    `username` varchar(255),
    `password` varchar(255),
    `company_id` int(11),
    `created_at` datetime,
    `updated_at` datetime,
    `email` varchar(255),
    `last_login_at` datetime,
    `admin` int(11),
    `time_zone` varchar(255),
    `option_tracktime` int(11),
    `option_externalclients` int(11),
    `option_tooltips` int(11),
    `seen_news_id` int(11),
    `last_project_id` int(11),
    `last_seen_at` datetime,
    `last_ping_at` datetime,
    `last_milestone_id` int(11),
    `last_filter` int(11),
    `date_format` varchar(255),
    `time_format` varchar(255),
    `send_notifications` int(11),
    `receive_notifications` int(11),
    `uuid` varchar(255),
    `seen_welcome` int(11),
    `locale` varchar(255),
    `duration_format` int(11),
    `workday_duration` int(11),
    `posts_count` int(11),
    `newsletter` int(11),
    `option_avatars` int(11),
    `autologin` varchar(255),
    `remember_until` datetime,
    `option_floating_chat` int(1),
    `days_per_week` int(11),
    `enable_sounds` int(1),
    `tmp_1` int(11),
    `tmp_2` int(11),
    `tmp_3` varchar(255),
  PRIMARY KEY  (`id`)
) DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

Drop Table If Exists `views`;
CREATE TABLE `views` (
    `id` int(11),
    `name` varchar(255),
    `company_id` int(11),
    `user_id` int(11),
    `shared` int(11),
    `auto_group` int(11),
    `filter_customer_id` int(11),
    `filter_project_id` int(11),
    `filter_milestone_id` int(11),
    `filter_user_id` int(11),
    `filter_tags` varchar(255),
    `filter_status` int(11),
    `filter_type_id` int(11),
    `hide_dependencies` int(11),
    `sort` int(11),
    `tmp_1` int(11),
    `tmp_2` int(11),
    `tmp_3` int(11),
  PRIMARY KEY  (`id`)
) DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

Drop Table If Exists `widgets`;
CREATE TABLE `widgets` (
    `id` int(11),
    `company_id` int(11),
    `user_id` int(11),
    `name` varchar(255),
    `widget_type` int(11),
    `number` int(11),
    `mine` int(1),
    `order_by` varchar(255),
    `group_by` varchar(255),
    `filter_by` varchar(255),
    `collapsed` int(1),
    `column` int(11),
    `position` int(11),
    `configured` int(1),
    `created_at` datetime,
    `updated_at` datetime,
    `gadget_url` text,
  PRIMARY KEY  (`id`)
) DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

Drop Table If Exists `wiki_pages`;
CREATE TABLE `wiki_pages` (
    `id` int(11),
    `company_id` int(11),
    `project_id` int(11),
    `created_at` datetime,
    `updated_at` datetime,
    `name` varchar(255),
    `locked_at` datetime,
    `locked_by` int(11),
  PRIMARY KEY  (`id`)
) DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

Drop Table If Exists `wiki_references`;
CREATE TABLE `wiki_references` (
    `id` int(11),
    `wiki_page_id` int(11),
    `referenced_name` varchar(255),
    `created_at` datetime,
    `updated_at` datetime,
  PRIMARY KEY  (`id`)
) DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

Drop Table If Exists `wiki_revisions`;
CREATE TABLE `wiki_revisions` (
    `id` int(11),
    `wiki_page_id` int(11),
    `created_at` datetime,
    `updated_at` datetime,
    `body` text,
    `user_id` int(11),
    `change` varchar(255),
  PRIMARY KEY  (`id`)
) DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

Drop Table If Exists `work_logs`;
CREATE TABLE `work_logs` (
    `id` int(11),
    `user_id` int(11),
    `task_id` int(11),
    `project_id` int(11),
    `company_id` int(11),
    `customer_id` int(11),
    `started_at` datetime,
    `duration` int(11),
    `body` text,
    `log_type` int(11),
    `scm_changeset_id` int(11),
    `paused_duration` int(11),
    `comment` int(1),
  PRIMARY KEY  (`id`)
) DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
