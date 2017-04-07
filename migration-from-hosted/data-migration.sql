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
-This scrpit will overwrite info you may have on the jobsworth database
*/

SET @new_company_id := 1;
SET @new_users_password := '{SSHA}3/Yuo32g8RoYg7e6hs/pkdIzPkk3NDlVU2pTRkhhZEhrWXBTQmVkSg==' ;
SET @new_users_password_salt := '749USjSFHadHkYpSBedJ';
SET @task_type := 'TaskRecord';

/* TABLES MIGRATED */

/* table companies;                              */
replace into 
jobsworth.companies(id,              name,contact_email,contact_name,created_at,updated_at,subdomain,show_wiki)
             select @new_company_id, name,contact_email,contact_name,created_at,updated_at,subdomain,show_wiki
               from clockingit.companies;

/* table customers;                              */
replace into 
jobsworth.customers(id,company_id,     name,contact_name,created_at,updated_at)
             select id,@new_company_id,name,contact_name,created_at,updated_at
               from clockingit.customers;
/* table dependencies;                           */
replace into 
jobsworth.dependencies(dependency_id,task_id)
                select id,task_id
                  from clockingit.dependencies;

/* table event_logs;                             */
replace into
jobsworth.event_logs(id,company_id     ,project_id,user_id,event_type,target_type,target_id,title,body,created_at,updated_at,user)
              select id,@new_company_id,project_id,user_id,event_type,target_type,target_id,title,body,created_at,updated_at,user
                from clockingit.event_logs;
                
/* table milestones;                             */
replace into 
jobsworth.milestones( id,company_id     ,project_id,user_id,name,description,due_at,`position`,completed_at,total_tasks,completed_tasks, status)
               select id,@new_company_id,project_id,user_id,name,description,due_at,`position`,completed_at,total_tasks,completed_tasks, if(completed_tasks < total_tasks,1,0) as status
                 from clockingit.milestones;

/* table news_items;                             */
replace into 
jobsworth.news_items(created_at,`body`,portal,company_id)
              select created_at,`body`,portal,@new_company_id
                from clockingit.news_items;

/* table project_permissions;                    */
replace into 
jobsworth.project_permissions(id,company_id,     project_id,user_id,created_at,can_comment,can_work,can_report,can_create,can_edit,can_reassign,can_close,can_grant,can_milestone)
                        select id,@new_company_id,project_id,user_id,created_at,can_comment,can_work,can_report,can_create,can_edit,can_reassign,can_close,can_grant,can_milestone
                         from clockingit.project_permissions;

/* table projects;                               */

replace into 
jobsworth.projects(id,name,company_id,     customer_id,created_at,updated_at,completed_at,critical_count,normal_count,low_count,description)
            select id,name,@new_company_id,customer_id,created_at,updated_at,completed_at,critical_count,normal_count,low_count,description
              from clockingit.projects;

/* table task_owners;                            */
replace into 
jobsworth.task_users (id,user_id,task_id)
               select id,user_id,task_id
                 from clockingit.task_owners;

/* table tags;                                   */
replace into 
jobsworth.tags (id,company_id     ,name)
         select id,@new_company_id,name
           from clockingit.tags;
/* table task_tags;                              */
replace into 
jobsworth.task_tags (tag_id,task_id)
         select tag_id,task_id
           from clockingit.task_tags;

/* table tasks;                                  */
replace into 
jobsworth.tasks (id,name,project_id,`position`,created_at,due_at,updated_at,completed_at,duration,hidden,milestone_id,description,company_id,     type      ,priority    ,updated_by_id,severity_id     ,type_id    ,task_num,
                 status,
                 creator_id,hide_until)
          select id,name,project_id,`position`,created_at,due_at,updated_at,completed_at,duration,hidden,milestone_id,description,@new_company_id,@task_type,(8 - priority),updated_by_id,(14 - severity_id),(type_id + 1),task_num,
                 case when status in (0,1,6) then 0 
                      when status in (2,3,4,5) then status - 1
                      else 0 
                 end as status,
                 creator_id, hide_until
            from clockingit.tasks;
            

replace into jobsworth.task_property_values(task_id,property_id,property_value_id)
                                     select id     ,1          ,(type_id + 1)       from clockingit.tasks;
replace into jobsworth.task_property_values(task_id,property_id,property_value_id)
                                     select id     ,2          ,(8 - priority)      from clockingit.tasks;
replace into jobsworth.task_property_values(task_id,property_id,property_value_id)
                                     select id     ,3          ,(14 - severity_id)  from clockingit.tasks;
                              

/* table todos;                                  */
replace into
jobsworth.todos(id,task_id,name,`position`,creator_id,completed_at,created_at,updated_at)
         select id,task_id,name,`position`,creator_id,completed_at,created_at,updated_at
           from clockingit.todos;

/* table users, email_addresses, work_plans;     */
replace into 
jobsworth.users (id,name,username,encrypted_password ,password_salt           ,customer_id    ,company_id     ,created_at,updated_at,admin,time_zone,option_tracktime,seen_news_id,last_project_id,last_seen_at,last_ping_at,last_milestone_id,last_filter,date_format,time_format,receive_notifications,uuid,seen_welcome,locale,option_avatars,autologin,remember_until,option_floating_chat,use_resources,need_schedule,can_approve_work_logs)
          select id,name,username,@new_users_password,@new_users_password_salt,@new_company_id,@new_company_id,created_at,updated_at,admin,time_zone,option_tracktime,seen_news_id,last_project_id,last_seen_at,last_ping_at,last_milestone_id,last_filter,date_format,time_format,receive_notifications,uuid,seen_welcome,locale,option_avatars,autologin,remember_until,option_floating_chat, 1,0,1
            from clockingit.users
           where username <> 'admin';

replace into
jobsworth.email_addresses(id,user_id,email,`default`,created_at,updated_at,company_id)
                   select id,     id,email,1        ,created_at,updated_at,@new_company_id
                     from clockingit.users
                    where username <> 'admin';

replace into
jobsworth.work_plans(id,user_id,created_at,updated_at)
              select id,id,     created_at,updated_at
                from clockingit.users
               where username <> 'admin';
/* pending: workday_duration, days_per_week */

/* table widgets;                                */
replace into
jobsworth.widgets(id,company_id     ,user_id,name,widget_type,number,mine,order_by,group_by,filter_by,collapsed,`column`,`position`,configured,created_at,updated_at,gadget_url)
           select id,@new_company_id,user_id,name,widget_type,number,mine,order_by,group_by,filter_by,collapsed,`column`,`position`,configured,created_at,updated_at,gadget_url
             from clockingit.widgets
            where widget_type <> 1; /* Workaround because of some widgets are failing */

/* table wiki_pages;                             */
replace into jobsworth.wiki_pages(id,company_id,project_id,created_at,updated_at,name,locked_at,locked_by)
                    select id,@new_company_id,project_id,created_at,updated_at,name,locked_at,locked_by 
                      from clockingit.wiki_pages;
/* table wiki_references;                        */
replace into jobsworth.wiki_references(id,wiki_page_id,referenced_name,created_at,updated_at)
                    select id,wiki_page_id,referenced_name,created_at,updated_at 
                      from clockingit.wiki_references;
/* table wiki_revisions;                         */
replace into jobsworth.wiki_revisions(id,wiki_page_id,created_at,updated_at,body,user_id)
                    select id,wiki_page_id,created_at,updated_at,body,user_id 
                      from clockingit.wiki_revisions;
/* table work_logs;                              */
replace into 
jobsworth.work_logs(id,user_id,task_id,project_id,company_id     ,customer_id,started_at,duration,body)
             select id,user_id,task_id,project_id,@new_company_id,customer_id,started_at,duration/60,body
               from clockingit.work_logs;

commit;

/* TABLES IGNORED */
/* table generated_reports;                      */
/* table ical_entries;                           */
/* table locales;                                */
/* table project_files;                          */ /* WHERE ARE THE BINARY FILES? */
/* table scm_changesets;                         */
/* table scm_files;                              */
/* table scm_projects;                           */
/* table sessions;                               */
/* table sheets;                                 */

/* TABLES THAT NOT EXISTS IN JOBSWORTH */
/* table activities;                             */
/* table chat_messages;                          */
/* table chats;                                  */
/* table emails;                                 */
/* table forums;                                 */
/* table logged_exceptions;                      */
/* table moderatorships;                         */
/* table monitorships;                           */
/* table notifications;                          */
/* table pages;                                  */
/* table posts;                                  */
/* table project_folders;                        */
/* table scm_revisions;                          */
/* table shout_channel_subscriptions;            */
/* table shout_channels;                         */
/* table shouts;                                 */
/* table topics;                                 */
/* table views;                                  */
