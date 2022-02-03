require 'rails_helper'

RSpec.describe 'step1', type: :system do

  let!(:task) { Task.create(title: 'task_title', content: 'task_content') }

  describe 'screen transition requirements' do
    describe '1. path prefix must be generated as per requirement' do
      it 'The path prefix is generated as per the requirement' do
        visit tasks_path
        visit new_task_path
        visit task_path(task)
        visit edit_task_path(task)
      end
      it 'The screen title of the "Tasks Index Page" should be displayed when the root is accessed' do
        visit root_path
        expect(page).to have_content 'Tasks Index Page'
      end
    end
  end

  describe 'Screen design requirements' do
    describe '2. display text, links and buttons on each screen as per requirements' do
      it 'Global navigation' do
        visit root_path
        expect(page).to have_link 'Tasks Index'
        expect(page).to have_link 'New Task'
      end
      it 'Task List Screen' do
        visit tasks_path
        expect(page).to have_content 'Tasks Index Page'
        expect(page).to have_link 'Show'
        expect(page).to have_link 'Edit'
        expect(page).to have_link 'Destroy'
      end
      it 'Task Registration Screen' do
        visit new_task_path
        expect(page).to have_content 'New Task Page'
        expect(page).to have_selector 'label', text: 'Title'
        expect(page).to have_selector 'label', text: 'Content'
        expect(page).to have_button 'Create Task'
        expect(page).to have_link 'Back'
      end
      it 'Task detail screen' do
        visit task_path(task)
        expect(page).to have_content 'Show Task Page'
        expect(page).to have_link 'Edit'
        expect(page).to have_link 'Back'
      end
      it 'Edit Task Page' do
        visit edit_task_path(task)
        expect(page).to have_content 'Edit Task Page'
        expect(page).to have_selector 'label', text: 'Title'
        expect(page).to have_selector 'label', text: 'Content'
        expect(page).to have_button 'Update Task'
        expect(page).to have_link 'Back'
      end
    end
    describe '3. HTML id and class attributes must be given as per requirement' do
      it 'Global Navigation' do
        visit root_path
        expect(page).to have_selector '#tasks-index', text: 'Tasks Index'
        expect(page).to have_selector '#new-task', text: 'New Task'
      end
      it 'List screen' do
        visit tasks_path
        expect(page).to have_selector '.show-task', text: 'Show'
        expect(page).to have_selector '.edit-task', text: 'Edit'
        expect(page).to have_selector '.destroy-task', text: 'Destroy'
      end
      it 'registration screen' do
        visit new_task_path
        expect(page).to have_selector '#create-task'
        expect(page).to have_selector '#back', text: 'Back'
      end
      it 'detail screen' do
        visit task_path(task)
        expect(page).to have_selector '#edit-task', text: 'Edit'
        expect(page).to have_selector '#back', text: 'Back'
      end
      it 'edit-task' do
        visit edit_task_path(task)
        expect(page).to have_selector '#update-task'
        expect(page).to have_selector '#back', text: 'Back'
      end
    end
    describe '4. List the titles, descriptions, and creation dates of the tasks registered in the list screen' do
      it '4. List the title, description, creation date and time of the registered tasks in the list screen' do
        visit tasks_path
        expect(page).to have_content task.title
        expect(page).to have_content task.content
        expect(page).to have_content task.created_at
      end
    end
    describe '5. display the title, description, and creation date of the task in the detail screen' do
      it '5. display the title, description, creation date and time of the task in the detail screen' do
        visit task_path(task)
        expect(page).to have_content task.title
        expect(page).to have_content task.content
        expect(page).to have_content task.created_at
      end
    end
  end

  describe 'Screen transition requirements' do
    describe '6. Make the transition as per the screen transition diagram' do
      it 'Ensure that global navigation links transition as per requirements' do
        visit tasks_path
        click_link 'New Task'
        expect(page).to have_content 'New Task Page'
        click_link 'Tasks Index'
        expect(page).to have_content 'Tasks Index Page'
      end
      it 'New Task Page will be displayed in the page title when you move from the list screen to the registration' do
        visit tasks_path
        find('#new-task').click
        expect(page).to have_content 'New Task Page'
      end
      it 'When a task is registered, "Tasks Index Page" will be displayed in the page title' do
        visit new_task_path
        fill_in 'Title', with: 'task_title'
        fill_in 'Content', with: 'task_content'
        find('#create-task').click
        expect(page).to have_content 'Tasks Index Page'
      end
      it 'If you click "Show", the page title will show "Show Task Page"' do
        visit tasks_path
        find('.show-task').click
        expect(page).to have_content 'Show Task Page'
      end
      it 'If you click "Edit", the page title will show "Edit Task Page"' do
        visit tasks_path
        find('.edit-task').click
        expect(page).to have_content 'Edit Task Page'
      end
      it 'If you click "Update Task", the page title will show "Index Task Page"' do
        visit edit_task_path(task)
        find('#update-task').click
        expect(page).to have_content 'Tasks Index Page'
      end
      it 'When "Destroy" is clicked, "Tasks Index Page" will be displayed in the page title' do
        visit tasks_path
        find('.destroy-task').click
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_content 'Tasks Index Page'
      end
      it 'When "Back" is clicked on the registration page, "Tasks Index Page" will be displayed in the page title' do
        visit new_task_path
        find('#back').click
        expect(page).to have_content 'Tasks Index Page'
      end
      it 'If you click "Back" on the detail screen, you will see "Tasks Index Page" in the page title' do
        visit task_path(task)
        find('#back').click
        expect(page).to have_content 'Tasks Index Page'
      end
      it 'When you click "Back" on the edit screen, "Tasks Index Page" will be displayed in the page title' do
        visit edit_task_path(task)
        find('#back').click
        expect(page).to have_content 'Tasks Index Page'
      end
      it 'If task registration fails, "New Task Page" will be displayed in the page title' do
        visit new_task_path
        fill_in 'Title', with: ''
        fill_in 'Content', with: ''
        find('#create-task').click
        expect(page).to have_content 'New Task Page'
      end
      it '"Edit Task Page" will be displayed in the page title if the task editing fails' do
        visit edit_task_path(task)
        fill_in 'Title', with: ''
        fill_in 'Content', with: ''
        find('#update-task').click
        expect(page).to have_content 'Edit Task Page'
      end
    end
  end

  describe 'Functional requirements' do
    describe '7. When clicking on a link to delete a task, the confirmation dialog should display the words "Are you sure?"' do
      it 'When you click on a link to delete a task, the confirmation dialog should display the words "Are you sure?' do
        visit tasks_path
        click_link 'Destroy'
        expect(page.driver.browser.switch_to.alert.text).to eq 'Are you sure?'
      end
    end
    describe '8. If validation fails on task registration or editing, display validation message as per requirement' do
      context 'Task registration screen' do
        it 'If the title is not entered, the validation message "Title can nott be blank" should be displayed' do
          visit new_task_path
          fill_in 'Title', with: ''
          fill_in 'Content', with: ''
          find('#create-task').click
          expect(page).to have_content "Title can not be blank"
        end
        it 'If the content is not entered, the validation message "Content can not be blank" will be displayed.' do
          visit new_task_path
          fill_in 'Title', with: ''
          fill_in 'Content', with: ''
          find('#create-task').click
          expect(page).to have_content "Content can not be blank"
        end
        it 'If the title and content are not entered, the validation messages "Title can not be blank" and "Content can not be blank" will be displayed.' do
          visit new_task_path
          fill_in 'Title', with: ''
          fill_in 'Content', with: ''
          find('#create-task').click
          expect(page).to have_content "Title can not be blank"
          expect(page).to have_content "Content can not be blank"
        end
      end
      context 'Task Edit Screen' do
        it 'If the title is not entered, the validation message "Title can not be blank" will be displayed.' do
          visit edit_task_path(task)
          fill_in 'Title', with: ''
          fill_in 'Content', with: ''
          find('#update-task').click
          expect(page).to have_content "Title can not be blank"
        end
        it 'If the content is not entered, a validation message "Content can not be blank" will be displayed.' do
          visit edit_task_path(task)
          fill_in 'Title', with: ''
          fill_in 'Content', with: ''
          find('#update-task').click
          expect(page).to have_content "Content can not be blank"
        end
        it 'If the title and content are not entered, the validation messages "Title can not be blank" and "Content can not be blank" will be displayed.' do
          visit edit_task_path(task)
          fill_in 'Title', with: ''
          fill_in 'Content', with: ''
          find('#update-task').click
          expect(page).to have_content "Title can not be blank"
          expect(page).to have_content "Content can not be blank"
        end
      end
    end
    describe '9. Display the flash message as per requirement' do
      context 'If the task was successfully registered' do
        it 'To display a flash message "Task was successfully created."' do
          visit new_task_path
          fill_in 'Title', with: 'sample title'
          fill_in 'Content', with: 'sample content'
          find('#create-task').click
          expect(page).to have_content "Task was successfully created."
        end
      end
      context 'If the task was successfully updated' do
        it 'To display a flash message "Task was successfully updated."' do
          visit edit_task_path(task)
          fill_in 'Title', with: 'update sample title'
          fill_in 'Content', with: 'update sample content'
          find('#update-task').click
          expect(page).to have_content "Task was successfully updated."
        end
      end
      context 'When a task is deleted' do
        it 'To display a flash message "Task was successfully destroyed."' do
          visit tasks_path
          find('.destroy-task').click
          page.driver.browser.switch_to.alert.accept
          expect(page).to have_content "Task was successfully destroyed."
        end
      end
    end
  end
end
