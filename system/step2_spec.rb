require 'rails_helper'

RSpec.describe 'step2', type: :system do

  describe 'development requirements' do
    let!(:task) { Task.create(title: 'task_title', content: 'task_content') }
    describe 'Internationalize text, links and buttons as per requirements using i18n' do
      it 'Global navigation' do
        visit root_path
        expect(page).to have_selector '#tasks-index', text: 'List of tasks'
        expect(page).to have_selector '#new-task', text: 'Register a task'
      end
      it 'task list screen' do
        visit tasks_path
        expect(page).to have_content 'Task List Page'
        expect(page).to have_selector '.show-task', text: 'Details'
        expect(page).to have_selector '.edit-task', text: 'edit'
        expect(page).to have_selector '.destroy-task', text: 'delete'
        find('.destroy-task').click
        expect(page.driver.browser.switch_to.alert.text).to eq 'Are you sure you want to delete this?'
      end
      it 'task registration screen' do
        visit new_task_path
        expect(page).to have_content 'Task registration page'
        expect(page).to have_selector 'label', text: 'Title'
        expect(page).to have_selector 'label', text: 'content'
        expect(page).to have_button 'Register'
        expect(page).to have_selector '#back', text: 'Back'
      end
      it 'task details screen' do
        visit task_path(task)
        expect(page).to have_content 'Task detail page'
        expect(page).to have_content 'Title'
        expect(page).to have_content 'Content'
        expect(page).to have_selector '#edit-task', text: 'edit'
        expect(page).to have_selector '#back', text: 'Back'
      end
      it 'task edit screen' do
        visit edit_task_path(task)
        expect(page).to have_content 'Edit Task Page'
        expect(page).to have_content 'Title'
        expect(page).to have_content 'Content'
        expect(page).to have_button 'Update'
        expect(page).to have_selector '#back', text: 'Back'
      end
      context 'Validation message' do
        it 'If the title and content are not entered in the task registration screen, the validation messages "Please enter a title" and "Please enter the content" will be displayed.' do
          visit new_task_path
          find('input[name="task[title]"]').set('')
          find('textarea[name="task[content]"]').set('')
          find('#create-task').click
          expect(page).to have_content "Please enter a title"
          expect(page).to have_content "Please enter the content"
        end
        it 'If the title and content are not entered in the task edit screen, the validation messages "Please enter a title" and "Please enter the content" will be displayed.' do
          visit edit_task_path(task)
          find('input[name="task[title]"]').set('')
          find('textarea[name="task[content]"]').set('')
          find('#update-task').click
          expect(page).to have_content "Please enter a title"
          expect(page).to have_content "Please enter the content"
        end
      end
      context 'Flash message' do
        it 'If the task was successfully registered,  the flash message "You have registered a task" will be displayed.' do
          visit new_task_path
          fill_in 'title', with: 'sample title'
          fill_in 'content', with: 'sample content'
          click_button 'register'
          expect(page).to have_content "You have registered a task"
        end
        it 'If the task was successfully updated,   the flash message "You have updated the task" will be displayed.' do
          visit edit_task_path(task)
          fill_in 'title', with: 'update sample title'
          fill_in 'content', with: 'update sample content'
          click_button 'update'
          expect(page).to have_content "You have updated the task"
        end
        it 'Deleting a task, the flash message "You have deleted the task" will be displayed.' do
          visit tasks_path
          click_link 'delete'
          page.driver.browser.switch_to.alert.accept
          expect(page).to have_content "You have deleted the task"
        end
      end
    end
    describe 'Set the creation date and time to be displayed in the task list screen to the time in your region' do
      it 'The creation date and time should not have the characters "UTC" which means Coordinated Universal Time.' do
        visit tasks_path
        expect(page).not_to_have_content "UTC"
      end
    end
    describe 'Setting the time for reading and writing data in the database to the time in your region' do
      it 'When outputting the data in the created_at column of the task, "+0900" should be displayed' do
        task = Task.create(title: 'task_title', content: 'task_content')
        expect(task.created_at.to_s).to include('+0900')
      end
    end
    describe 'To be able to submit task data for 50 tasks using seed data' do
      before do
        load Rails.root.join("db/seeds.rb")
      end
      it 'To be able to use seed data to populate 50 tasks' do
        expect(Task.all.count).to be >= 50
      end
    end
  end

  describe 'functional requirements' do
    before do
      50.times do |n|
        Task.create(title: "task_title_#{n+1}", content: "task_content_#{n+1}")
      end
    end
    describe 'Display tasks in the task list screen in descending order by creation date and time' do
      it 'To display tasks in descending order of creation date in the task list screen' do
        visit tasks_path
        tasks = all('tbody tr')
        expect(tasks[0].text).to include('task_title_50')
        expect(tasks[1].text).to include('task_title_49')
        expect(tasks[2].text).to include('task_title_48')
        expect(tasks[3].text).to include('task_title_47')
        expect(tasks[4].text).to include('task_title_46')
        expect(tasks[5].text).to include('task_title_45')
        expect(tasks[6].text).to include('task_title_44')
        expect(tasks[7].text).to include('task_title_43')
        expect(tasks[8].text).to include('task_title_42')
        expect(tasks[9].text).to include('task_title_41')
      end
    end
    describe "Using kaminari's gem, implement pagination in the task list screen to display 10 tasks per page" do
      it 'There should be a pagination class created when kaminari is applied to the task list screen' do
        visit tasks_path
        expect(page).to have_css '.pagination'
      end
      it 'The HTML class attributes (show-task, edit-task, destroy-task) assigned to the tasks should be displayed for 10 tasks' do
        visit tasks_path
        expect(all('.show-task').count()).to eq 10
        expect(all('.edit-task').count()).to eq 10
        expect(all('.destroy-task').count()).to eq 10
      end
    end
  end
end
