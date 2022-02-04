require 'rails_helper'

RSpec.describe 'step5', type: :system do

  let!(:user) { User.create(name: 'user_name', email: 'user@email.com', password: 'password') }
  let!(:admin) { User.create(name: 'admin_name', email: 'admin@email.com', password: 'password', admin: true) }
  let!(:task_created_by_user){ Task.create(title: 'task_title', content: 'task_content', deadline_on: Date.today, priority: 0, status: 0, user_id: user.id)}
  let!(:task_created_by_admin){Task.create(title: 'task_title', content: 'task_content', deadline_on: Date.today, priority: 0, status: 0, user_id: admin.id)}
  let!(:label_created_by_user) { Label.create(name: 'label_name', user_id: user.id)}
  let!(:label_created_by_admin) { Label.create(name: 'label_name', user_id: admin.id)}

  describe 'Screen transition requirements' do
    describe '1. path prefix can be used as per requirement' do
      context 'When you are logged in as a regular user' do
        before do
          visit root_path
          click_link 'Login' do
          find('input[name="session[email]"]').set(user.email)
          find('input[name="session[password]"]').set(user.password)
          click_button 'login'
        end
        it 'The path prefix can be used as per requirement' do
          visit labels_path
          visit new_label_path
          visit edit_label_path(label_created_by_user)
        end
      end
      context 'If you are logged in as administrator' do
        before do
          visit root_path
          find('#sign-in').click
          find('input[name="session[email]"]').set(admin.email)
          find('input[name="session[password]"]').set(admin.password)
          find('#create-session').click
        end
        it 'The path prefix can be used as per requirement' do
          visit labels_path
          visit new_label_path
          visit edit_label_path(label_created_by_admin)
        end
      end
    end end
  end

  describe 'Screen design requirements' do
    describe '2. HTML id and class attributes must be assigned as per requirements' do
      context 'When you are logged out' do
        it 'Global navigation' do
          visit root_path
          expect(page).not_to have_css '#labels-index'
          expect(page).not_to have_css '#new-label'
        end
      end
      context 'If you are logged in as a regular user' do
        before do
          visit root_path
          find('#sign-in').click
          find('input[name="session[email]"]').set(user.email)
          find('input[name="session[password]"]').set(user.password)
          find('#create-session').click
        end
        it 'global navigation' do
          expect(page).to have_css '#labels-index'
          expect(page).to have_css '#new-label'
        end
      end
      context 'If you are logged in as administrator' do
        before do
          visit root_path
          find('#sign-in').click
          find('input[name="session[email]"]').set(admin.email)
          find('input[name="session[password]"]').set(admin.password)
          find('#create-session').click
        end
        it 'global navigation' do
          expect(page).to have_css '#labels-index'
          expect(page).to have_css '#new-label'
        end
      end
    end
  end

  describe 'Screen design requirements' do
    describe '3. Display text, links and buttons on each screen as per requirements' do
      context 'When you are logged out' do
        it 'Global navigation' do
          visit root_path
          expect(page).not_to have_link 'List of labels'
          expect(page).not_to have_link 'Register label'
        end
      end
      context 'When logged in as a regular user' do
        before do
          visit new_session_path
          find('input[name="session[email]"]').set(user.email)
          find('input[name="session[password]"]').set(user.password)
          click_button 'login'
        end
        it 'global navigation' do
          expect(page).to have_link 'List of labels'
          expect(page).to have_link 'Register a label'
        end
        it 'label list screen' do
          visit labels_path
          expect(page).to have_content 'Name'
          expect(page).to have_content 'Number of tasks'
          expect(page).to have_link 'edit'
          expect(page).to have_link 'delete'
        end
        it 'label registration screen' do
          visit new_label_path
          expect(page).to have_content 'label registration page'
          expect(page).to have_selector 'label', text: 'name'
          expect(page).to have_button 'Register'
          expect(page).to have_link 'Return'
        end
        it 'label edit screen' do
          visit edit_label_path(label_created_by_user)
          expect(page).to have_content 'Edit Label Page'
          expect(page).to have_selector 'label', text: 'name'
          expect(page).to have_button 'Update'
          expect(page).to have_link 'Back'
        end
        it 'task registration screen' do
          visit new_task_path
          expect(page).to have_selector 'label', text: 'label'
          expect(find('input[type="checkbox"]')).to be_visible
          expect(page).to have_button 'Register'
          expect(page).to have_link 'Return'
        end
        it 'task edit screen' do
          visit edit_task_path(task_created_by_user)
          expect(page).to have_selector 'label', text: 'label'
          expect(find('input[type="checkbox"]')).to be_visible
          expect(page).to have_button 'update'
          expect(page).to have_link 'return'
        end
      end
      context 'If you are logged in as administrator' do
        before do
          visit new_session_path
          find('input[name="session[email]"]').set(admin.email)
          find('input[name="session[password]"]').set(admin.password)
          click_button 'login'
        end
        it 'global navigation' do
          expect(page).to have_link 'List of labels'
          expect(page).to have_link 'Register a label'
        end
        it 'label list screen' do
          visit labels_path
          expect(page).to have_content 'Name'
          expect(page).to have_content 'Number of tasks'
          expect(page).to have_link 'edit'
          expect(page).to have_link 'delete'
        end
        it 'label registration screen' do
          visit new_label_path
          expect(page).to have_content 'label registration page'
          expect(page).to have_selector 'label', text: 'name'
          expect(page).to have_button 'Register'
          expect(page).to have_link 'Return'
        end
        it 'label edit screen' do
          visit edit_label_path(label_created_by_admin)
          expect(page).to have_content 'Edit Label Page'
          expect(page).to have_selector 'label', text: 'name'
          expect(page).to have_button 'Update'
          expect(page).to have_link 'Back'
        end
      end
    end

    describe '4. In the label list screen, the number of tasks associated with the label should be displayed' do
      before do
        visit new_session_path
        find('input[name="session[email]"]').set(user.email)
        find('input[name="session[password]"]').set(user.password)
        click_button 'login'
      end
      it 'The label list screen should display the number of tasks associated with the label' do
        3.times do |t|
          task = Task.create(title: "task_title_#{t+10}", content: "task_content_#{t+10}", deadline_on: Date.today, priority: 0, status: 0, user_id: user.id)
          task.labels << label_created_by_user
        end
        visit labels_path
        expect(page).to have_content(3)
      end
    end
    describe '5. To display a form label named "label" and a checkbox to select the label in the task registration and editing screens' do
      before do
        visit new_session_path
        find('input[name="session[email]"]').set(user.email)
        find('input[name="session[password]"]').set(user.password)
        click_button 'login'
      end
      it 'task registration screen' do
        visit new_task_path
        expect(page).to have_selector 'label', text: 'label'
        expect(find('input[type="checkbox"]')).to be_visible
      end
      it 'task edit screen' do
        visit edit_task_path(task_created_by_user)
        expect(page).to have_selector 'label', text: 'label'
        expect(find('input[type="checkbox"]')).to be_visible
      end
    end
    describe '6. In the task edit screen, the label associated with the task should be displayed with the checkbox checked' do
      before do
        visit new_session_path
        find('input[name="session[email]"]').set(user.email)
        find('input[name="session[password]"]').set(user.password)
        click_button 'login'
      end
      it 'In the task edit screen, the label associated with the task should be displayed with a check mark.' do
        10.times { |t| Label.create!(id: t+1, name: "label_#{t+1}", user_id: user.id) }
        task_created_by_user.labels << Label.find(2,7,9)
        visit edit_task_path(task_created_by_user)
        expect(page).to have_checked_field('label_2')
        expect(page).to have_checked_field('label_7')
        expect(page).to have_checked_field('label_9')
        expect(page).to have_unchecked_field('label_1')
        expect(page).to have_unchecked_field('label_3')
        expect(page).to have_unchecked_field('label_4')
        expect(page).to have_unchecked_field('label_5')
        expect(page).to have_unchecked_field('label_6')
        expect(page).to have_unchecked_field('label_8')
        expect(page).to have_unchecked_field('label_10')
      end
    end
    describe '7. Add a field called "Label" to the task detail screen and display all the label names associated with the task' do
      before do
        visit new_session_path
        find('input[name="session[email]"]').set(user.email)
        find('input[name="session[password]"]').set(user.password)
        click_button 'login'
      end
      it 'Display all label names associated with the task' do
        10.times { |t| Label.create!(id: t+1, name: "label_#{t+1}", user_id: user.id) }
        task_created_by_user.labels << Label.find(2,7,9)
        visit task_path(task_created_by_user)
        expect(page).to have_content 'Label'
        expect(page).to have_content 'label_2'
        expect(page).to have_content 'label_7'
        expect(page).to have_content 'label_9'
        expect(page).not_to_have_content 'label_1'
        expect(page).not_to have_content 'label_3'
        expect(page).not_to have_content 'label_4'
        expect(page).not_to have_content 'label_5'
        expect(page).not_to have_content 'label_6'
        expect(page).not_to have_content 'label_8'
        expect(page).not_to have_content 'label_10'
      end
    end
  end

  describe 'Screen transition requirements' do
    describe '8. Make the transition according to the screen transition diagram' do
      before do
        visit new_session_path
        find('input[name="session[email]"]').set(user.email)
        find('input[name="session[password]"]').set(user.password)
        click_button 'login'
      end
      it 'Make global navigation links transition as per requirements' do
        click_link 'List of labels'
        expect(page).to have_content 'List of labels page'
        click_link 'Register a label'
        expect(page).to have_content 'Register Label Page'
      end
      it 'If the label is successfully registered, "Label List Page" will be displayed in the page title' do
        visit new_label_path
        find('input[name="label[name]"]').set('new_label_name')
        click_button 'register'
        expect(page).to have_content 'Label List Page'
      end
      it 'If label registration fails, "label registration page" will be displayed in the page title' do
        visit new_label_path
        find('input[name="label[name]"]').set('')
        click_button 'Register'
        expect(page).to have_content 'label registration page'
      end
      it 'If the label is successfully edited, "Label List Page" will be displayed in the page title' do
        visit edit_label_path(label_created_by_user)
        find('input[name="label[name]"]').set('edit_label_name')
        click_button 'update'
        expect(page).to have_content 'Label List Page'
      end
      it 'If editing a label fails, "Edit Label Page" will be displayed in the page title' do
        visit edit_label_path(label_created_by_user)
        find('input[name="label[name]"]').set('')
        click_button 'update'
        expect(page).to have_content 'label edit page'
      end
      it 'When "Edit" is clicked on the label list screen, "Label Edit Page" will be displayed in the page title' do
        visit labels_path
        click_link 'edit', href: edit_label_path(label_created_by_user)
        expect(page).to have_content 'Edit Label Page'
      end
      it 'When "Delete" is clicked on the label list page, "Label List Page" will be displayed in the page title' do
        visit labels_path
        click_link 'delete', href: label_path(label_created_by_user)
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_content 'label list page'
      end
      it 'When "Back" is clicked on the label registration page, "Label List Page" will be displayed in the page title' do
        visit new_label_path
        click_link 'back'
        expect(page).to have_content 'Label List Page'
      end
      it 'When "Back" is clicked on the label edit screen, "Label List Page" will be displayed in the page title' do
        visit edit_label_path(label_created_by_user)
        click_link 'back'
        expect(page).to have_content 'Label List Page'
      end
    end
  end

  describe 'Basic requirements' do
    before do
      visit root_path
      find('#sign-in').click
      find('input[name="session[email]"]').set(admin.email)
      find('input[name="session[password]"]').set(admin.password)
      find('#create-session').click
    end
    describe '9. Implement the search form for labels by adding it to the search form in the task list screen implemented in step 3' do
      it 'Implement the search form for labels by adding it to the search form in the task list screen implemented in Step 3' do
        visit tasks_path
        expect(page).to have_css '#search_label_id'
      end
    end
    describe '10. Use select for the label search form and leave the default value empty' do
      it 'Use select for label search form, default value should be empty' do
        visit tasks_path
        expect(find('#search_label_id').all('option')[0].text).to be_blank
      end
    end
  end

  describe 'Functional requirements' do
    describe '11. Be able to label tasks when registering or editing them' do
      before do
        visit new_session_path
        find('input[name="session[email]"]').set(user.email)
        find('input[name="session[password]"]').set(user.password)
        click_button 'login'
      end
      it 'Allow labeling when registering a task' do
        visit new_task_path
        find('input[name="task[title]"]').set('task_title')
        find('textarea[name="task[content]"]').set('task_content')
        find('input[name="task[deadline_on]"]').set(Date.today)
        select 'high', from: 'task[priority]'
        select 'not started', from: 'task[status]'
        check label_created_by_user.name
        click_button 'register'
      end
      it 'To be able to label a task when editing it' do
        visit edit_task_path(task_created_by_user)
        find('input[name="task[title]"]').set('task_title')
        find('textarea[name="task[content]"]').set('task_content')
        find('input[name="task[deadline_on]"]').set(Date.today)
        select 'high', from: 'task[priority]'
        select 'not started', from: 'task[status]'
        check label_created_by_user.name
        click_button 'update'
      end
    end

    describe '12. Allowing multiple labels to be registered for a single task' do
      before do
        visit new_session_path
        find('input[name="session[email]"]').set(user.email)
        find('input[name="session[password]"]').set(user.password)
        click_button 'login'
      end
      context 'task registration screen' do
        it 'Allow multiple labels to be registered for a single task' do
          10.times { |t| Label.create!(name: "label_#{t+1}", user_id: user.id) }
          visit new_task_path
          find('input[name="task[title]"]').set('task_title')
          find('textarea[name="task[content]"]').set('task_content')
          find('input[name="task[deadline_on]"]').set(Date.today)
          select 'high', from: 'task[priority]'
          select 'not started', from: 'task[status]'
          check 'label_1'
          check 'label_3'
          check 'label_5'
          check 'label_7'
          check 'label_9'
          click_button 'register'
          visit task_path(user.tasks.last)
          expect(page).to have_content 'label_1'
          expect(page).to have_content 'label_3'
          expect(page).to have_content 'label_5'
          expect(page).to have_content 'label_7'
          expect(page).to have_content 'label_9'
        end
      end
      context 'task edit screen' do
        it 'Allow multiple labels to be registered for a single task' do
          10.times { |t| Label.create!(name: "label_#{t+1}", user_id: user.id) }
          visit edit_task_path(task_created_by_user)
          find('input[name="task[title]"]').set('task_title')
          find('textarea[name="task[content]"]').set('task_content')
          find('input[name="task[deadline_on]"]').set(Date.today)
          select 'high', from: 'task[priority]'
          select 'not started', from: 'task[status]'
          check 'label_2'
          check 'label_4'
          check 'label_6'
          check 'label_8'
          check 'label_10'
          click_button 'update'
          visit task_path(task_created_by_user)
          expect(page).to have_content 'label_2'
          expect(page).to have_content 'label_4'
          expect(page).to have_content 'label_6'
          expect(page).to have_content 'label_8'
          expect(page).to have_content 'label_10'
        end
      end
    end

    describe '13. When you click on the link to remove a label, the confirmation dialog should say "Are you sure you want to remove it?"' do
      before do
        visit new_session_path
        find('input[name="session[email]"]').set(user.email)
        find('input[name="session[password]"]').set(user.password)
        click_button 'login'
      end
      it 'When you click on the link to delete a label, a confirmation dialog should appear with the text "Are you sure you want to delete this? in the confirmation dialog when clicking the link to delete the label.' do
        visit labels_path
        click_link 'delete', href: label_path(label_created_by_user)
        expect(page.driver.browser.switch_to.alert.text).to eq 'Are you sure you want to delete this?'
      end
    end

    describe '14. Display the flash message as per requirement' do
      before do
        visit new_session_path
        find('input[name="session[email]"]').set(user.email)
        find('input[name="session[password]"]').set(user.password)
        click_button 'login'
      end
      context 'If the label was registered successfully' do
        it 'To display a flash message "You have registered a label"' do
          visit new_label_path
          find('input[name="label[name]"]').set('new_label_name')
          click_button 'Register'
          expect(page).to have_content 'You have registered the label'
        end
      end
      context 'If the label was successfully updated' do
        it 'To display a flash message "Label updated"' do
          visit edit_label_path(label_created_by_user)
          find('input[name="label[name]"]').set('new_label_name')
          click_button 'update'
          expect(page).to have_content 'Updated the label'
        end
      end
      context 'Removed the label' do
        it 'To display a flash message "Label removed"' do
          visit labels_path
          click_link 'deleted', href: label_path(label_created_by_user)
          page.driver.browser.switch_to.alert.accept
          expect(page).to have_content 'Label removed'
        end
      end
    end

    describe '15. To display a validation message "Please enter a name" when a user tries to register or update a label without entering a name' do
      before do
        visit new_session_path
        find('input[name="session[email]"]').set(user.email)
        find('input[name="session[password]"]').set(user.password)
        click_button 'login'
      end
      it 'To display a validation message "Please enter a name" when a user tries to register a label without entering a name' do
        visit new_label_path
        find('input[name="label[name]"]').set('')
        click_button 'Register'
        expect(page).to have_content 'Please enter your name'
      end
      it 'To display a validation message "Please enter a name" when you try to update a label without entering its name' do
        visit edit_label_path(label_created_by_user)
        find('input[name="label[name]"]').set('')
        click_button 'update'
        expect(page).to have_content 'Please enter your name'
      end
    end

    describe '16. Make sure that the registered label can only be used by the user who registered the label' do
      let!(:second_user) { User.create(name: 'second_user_name', email: 'second_user@email.com', password: 'password') }
      before do
        visit new_session_path
        find('input[name="session[email]"]').set(user.email)
        find('input[name="session[password]"]').set(user.password)
        click_button 'login'
      end
      it 'Labels created by other users will not be displayed in the task registration screen' do
        10.times { |t| Label.create!(id: t+1, name: "label_#{t+1}", user: second_user) }
        visit new_task_path
        expect(page).not_to have_content 'label_1'
        expect(page).not_to have_content 'label_2'
        expect(page).not_to have_content 'label_3'
        expect(page).not_to have_content 'label_4'
        expect(page).not_to have_content 'label_5'
        expect(page).not_to have_content 'label_6'
        expect(page).not_to have_content 'label_7'
        expect(page).not_to have_content 'label_8'
        expect(page).not_to have_content 'label_9'
        expect(page).not_to have_content 'label_10'
      end
      it 'Labels created by other users will not be displayed in the task edit screen' do
        10.times { |t| Label.create!(id: t+1, name: "label_#{t+1}", user: second_user) }
        visit edit_task_path(task_created_by_user)
        expect(page).not_to have_content 'label_1'
        expect(page).not_to have_content 'label_2'
        expect(page).not_to have_content 'label_3'
        expect(page).not_to have_content 'label_4'
        expect(page).not_to have_content 'label_5'
        expect(page).not_to have_content 'label_6'
        expect(page).not_to have_content 'label_7'
        expect(page).not_to have_content 'label_8'
        expect(page).not_to have_content 'label_9'
        expect(page).not_to have_content 'label_10'
      end
    end

    describe '17. specify one label and search for it to show only tasks with that label' do
      before do
        visit new_session_path
        find('input[name="session[email]"]').set(user.email)
        find('input[name="session[password]"]').set(user.password)
        click_button 'login'
      end
      it 'To specify one label and search for it to display only the tasks with that label' do
        5.times do |t|
          Task.create(title: "task_title_#{t+2}", content: "task_content_#{t+2}", deadline_on: Date.today, priority: 0, status: 0, user_id: user.id)
          task = Task.create(title: "task_title_#{t+7}", content: "task_content_#{t+7}", deadline_on: Date.today, priority: 0, status: 0, user_id: user.id)
          task.labels << label_created_by_user
        end
        visit tasks_path
        select label_created_by_user.name, from: 'search[label_id]'
        click_button 'search'
        sleep 0.5
        expect(page).to have_content 'task_title_7'
        expect(page).to have_content 'task_title_8'
        expect(page).to have_content 'task_title_9'
        expect(page).to have_content 'task_title_10'
        expect(page).to have_content 'task_title_11'
        expect(page).not_to have_content 'task_title_2'
        expect(page).not_to have_content 'task_title_3'
        expect(page).not_to have_content 'task_title_4'
        expect(page).not_to have_content 'task_title_5'
        expect(page).not_to have_content 'task_title_6'
      end
    end
  end
end
