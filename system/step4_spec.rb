require 'rails_helper'

RSpec.describe 'step4', type: :system do

  let!(:user) { User.create(name: 'user_name', email: 'user@email.com', password: 'password') }
  let!(:admin) { User.create(name: 'admin_name', email: 'admin@email.com', password: 'password', admin: true) }

  describe 'Screen transition requirements' do
    describe '1. path prefix can be used as per requirement' do
      context 'If you are logged out' do
        it 'The path prefix can be used as per requirement' do
          visit new_session_path
          visit new_user_path
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
        it 'The path prefix can be used as per requirement' do
          visit user_path(user)
          visit edit_user_path(user)
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
          visit admin_users_path
          visit new_admin_user_path
          visit admin_user_path(user)
          visit edit_admin_user_path(user)
        end
      end
    end
  end

  describe 'Screen design requirements' do
    describe '2. HTML id and class attributes must be assigned as per requirements' do
      context 'When you are logged out' do
        it 'Global navigation' do
          visit root_path
          expect(page).to have_css '#sign-up'
          expect(page).to have_css '#sign-in'
          expect(page).not_to have_css '#my-account'
          expect(page).not_to have_css '#sign-out'
          expect(page).not_to have_css '#users-index'
          expect(page).not_to have_css '#new-user'
        end
        it 'login screen' do
          visit root_path
          find('#sign-in').click
          expect(page).to have_css '#create-session'
        end
        it 'account registration screen' do
          visit root_path
          find('#sign-up').click
          expect(page).to have_css '#create-user'
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
          expect(page).to have_css '#my-account'
          expect(page).to have_css '#sign-out'
          expect(page).not_to have_css '#users-index'
          expect(page).not_to have_css '#new-user'
          expect(page).not_to have_css '#sign-up'
          expect(page).not_to have_css '#sign-in'
        end
        it 'Account details screen' do
          find('#my-account').click
          expect(page).to have_css '#edit-user'
        end
        it 'Edit account screen' do
          find('#my-account').click
          find('#edit-user').click
          expect(page).to have_css '#update-user'
          expect(page).to have_css '#back'
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
          expect(page).to have_css '#my-account'
          expect(page).to have_css '#sign-out'
          expect(page).to have_css '#users-index'
          expect(page).to have_css '#new-user'
          expect(page).not_to have_css '#sign-up'
          expect(page).not_to have_css '#sign-in'
        end
        it 'users list screen' do
          find('#users-index').click
          expect(page).to have_css '.show-user'
          expect(page).to have_css '.edit-user'
          expect(page).to have_css '.destroy-user'
        end
        it 'User registration screen (for administrators)' do
          find('#users-index').click
          find("#new-user").click
          expect(page).to have_css '#create-user'
        end
        it 'User edit screen (for admin)' do
          find('#users-index').click
          all(".edit-user")[0].click
          expect(page).to have_css '#update-user'
          expect(page).to have_css '#back'
        end
      end
    end
  end

  describe 'Screen design requirements' do
    describe '3. Display text, links and buttons on each screen as per requirements' do
      context 'When you are logged out' do
        it 'Global navigation' do
          visit root_path
          expect(page).to have_link 'Register for an account'
          expect(page).to have_link 'Login'
        end
        it 'login screen' do
          visit root_path
          click_link 'login'
          expect(page).to have_content 'login page'
          expect(page).to have_selector 'label', text: 'email address'
          expect(page).to have_selector 'label', text: 'Password'
          expect(page).to have_button 'login'
        end
        it 'account registration screen' do
          visit root_path
          click_link 'Register account'
          expect(page).to have_content 'Account registration page'
          expect(page).to have_selector 'label', text: 'name'
          expect(page).to have_selector 'label', text: 'Email address'
          expect(page).to have_selector 'label', text: 'Password'
          expect(page).to have_selector 'label', text: 'Password (confirmation)'
          expect(page).to have_button 'Register'
        end
      end
      context 'If you are logged in as a regular user' do
        before do
          visit new_session_path
          find('input[name="session[email]"]').set(user.email)
          find('input[name="session[password]"]').set(user.password)
          click_button 'login'
        end
        it 'global navigation' do
          expect(page).to have_link 'Task List'
          expect(page).to have_link 'Register a task'
          expect(page).to have_link 'Account'
          expect(page).to have_link 'Logout'
        end
        it 'Account details screen' do
          click_link 'Account'
          expect(page).to have_content 'Account details page'
          expect(page).to have_content 'Name'
          expect(page).to have_content 'Email address'
          expect(page).to have_link 'Edit'
        end
        it 'account edit screen' do
          click_link 'Account'
          click_link 'edit'
          expect(page).to have_content 'Account edit page'
          expect(page).to have_selector 'label', text: 'name'
          expect(page).to have_selector 'label', text: 'Email address'
          expect(page).to have_selector 'label', text: 'Password'
          expect(page).to have_selector 'label', text: 'Password (confirmation)'
          expect(page).to have_button 'Update'
          expect(page).to have_link 'Back'
        end
      end
      context 'If you are logged in as an admin user' do
        before do
          visit new_session_path
          find('input[name="session[email]"]').set(admin.email)
          find('input[name="session[password]"]').set(admin.password)
          click_button 'login'
        end
        it 'global navigation' do
          expect(page).to have_link 'User List'
          expect(page).to have_link 'Register a user'
          expect(page).to have_link 'List of tasks'
          expect(page).to have_link 'Register a task'
          expect(page).to have_link 'Account'
          expect(page).to have_link 'Logout'
        end
        it 'User List Screen' do
          click_link 'User List'
          expect(page).to have_content 'User List Page'
          expect(page).to have_selector 'thead', text: 'name'
          expect(page).to have_selector 'head', text: 'email address'
          expect(page).to have_selector 'thead', text: 'Administrator rights'
          expect(page).to have_selector 'thead', text: 'Number of tasks'
          expect(page).to have_link 'details'
          expect(page).to have_link 'edit', text: 'edit'
          expect(page).to have_link 'delete'
        end
        it 'user registration screen' do
          click_link 'Register a user'
          expect(page).to have_content 'User registration page'
          expect(page).to have_selector 'label', text: 'name'
          expect(page).to have_selector 'label', text: 'Email address'
          expect(page).to have_selector 'label', text: 'Password'
          expect(page).to have_selector 'label', text: 'Password (confirmation)'
          expect(page).to have_selector 'label', text: 'Administrator rights'
          expect(page).to have_button 'Register'
          expect(page).to have_link 'Return'
        end
        it 'user details screen' do
          click_link 'user list'
          all(".show-user")[0].click
          expect(page).to have_content 'User details page'
          expect(page).to have_content 'Name'
          expect(page).to have_content 'Email address'
          expect(page).to have_content 'Administrator rights'
          expect(page).to have_selector 'thead', text: 'title'
          expect(page).to have_selector 'thead', text: 'content'
          expect(page).to have_selector 'head', text: 'Creation date'
          expect(page).to have_selector 'thead', text: 'End date'
          expect(page).to have_selector 'thead', text: 'Priority'
          expect(page).to have_selector 'thead', text: 'status'
        end
        it 'User edit screen' do
          click_link 'user list'
          all(".edit-user")[0].click
          expect(page).to have_content 'edit user page'
          expect(page).to have_selector 'label', text: 'name'
          expect(page).to have_selector 'label', text: 'email address'
          expect(page).to have_selector 'label', text: 'Password'
          expect(page).to have_selector 'label', text: 'Password (confirmation)'
          expect(page).to have_selector 'label', text: 'Administrator rights'
          expect(page).to have_button 'Update'
          expect(page).to have_link 'Back'
        end
      end
    end

    describe '4. The number of tasks created by each user should be displayed in the user list screen' do
      before do
        visit new_session_path
        find('input[name="session[email]"]').set(admin.email)
        find('input[name="session[password]"]').set(admin.password)
        click_button 'login'
      end
      it 'The user list screen should show the number of tasks each user has created' do
        10.times do
          Task.create(title: 'task_title', content: 'task_content', deadline_on: Date.today, priority: 0, status: 0, user_id: user.id)
        end
        5.times do
          Task.create(title: 'task_title', content: 'task_content', deadline_on: Date.today, priority: 0, status: 0, user_id: admin.id)
        end
        visit root_path
        click_link 'user list'
        expect(page).to have_content '10'
        expect(page).to have_content '5'
      end
    end

    describe "5. Display 'Yes' if the user has admin rights and 'No' if the user doesn't have admin rights in the admin rights section of the user list screen" do
      before do
        visit new_session_path
        find('input[name="session[email]"]').set(admin.email)
        find('input[name="session[password]"]').set(admin.password)
        click_button 'login'
      end
      it 'If the user is only an administrator, make the user list show "Yes"' do
        User.destroy_by(name: 'user_name')
        click_link 'User list'
        expect(page).to have_content 'Yes'
        expect(page).not_to_have_content 'none'
      end
      it "If there are general users and administrators, make the user list show 'yes' and 'no'" do
        click_link 'user list'
        expect(page).to have_content 'Yes'
        expect(page).to have_content 'none'
      end
    end

    describe "6. Display 'Yes' if the user has admin rights and 'No' if the user does not have admin rights in the admin rights section of the user details screen" do
      before do
        visit new_session_path
        find('input[name="session[email]"]').set(admin.email)
        find('input[name="session[password]"]').set(admin.password)
        click_button 'login'
      end
      it "If you are an administrator, make sure 'Yes' is displayed" do
        click_link 'User List'
        click_link 'details', href: admin_user_path(admin)
        expect(page).to have_content 'Yes'
      end
      it 'For general users, "No" will be displayed' do
        click_link 'User List'
        click_link 'Details', href: admin_user_path(user)
        expect(page).to have_content 'None'
      end
    end

    describe '7. To list the title, content, due date, priority, and status of tasks created by the user in the user detail screen' do
      before do
        visit new_session_path
        find('input[name="session[email]"]').set(admin.email)
        find('input[name="session[password]"]').set(admin.password)
        click_button 'login'
      end
      it 'To display the registered task information in a list' do
        10.times do |n|
          Task.create(title: "task_title_#{n}", content: "task_content_#{n}", deadline_on: Date.today, priority: n%3, status: n%3, user_id: user.id)
        end
        click_link 'User List'
        click_link 'Details', href: admin_user_path(user)
        10.times do |n|
          expect(page).to have_content "task_title_#{n}"
        end
        10.times do |n| expect(page).to have_content "task_title_#{n}"
          expect(page).to have_content "task_content_#{n}"
        end
        expect(page).to have_content 'high'
        expect(page).to have_content 'medium'
        expect(page).to have_content 'low'
        expect(page).to have_content 'Not started'
        expect(page).to have_content 'Work in progress'
        expect(page).to have_content 'Completed'
      end
    end
  end

  describe '8. screen transition requirements' do
    describe 'Make the transition as per the screen transition diagram' do
      context 'In case of logout' do
        it 'Make global navigation links transition as per requirements' do
          visit root_path
          click_link 'login'
          expect(page).to have_content 'Login page'
          click_link 'Register account'
          expect(page).to have_content 'Account registration page'
        end
        it 'If the account registration is successful, "Task List Page" will be displayed in the page title' do
          visit new_user_path
          find('input[name="user[name]"]').set('new_user_name')
          find('input[name="user[email]"]').set('new_user@email.com')
          find('input[name="user[password]"]').set('new_password')
          find('input[name="user[password_confirmation]"]').set('new_password')
          click_button 'Register'
          expect(page).to have_content 'Task List Page'
        end
        it 'If account registration fails, "Account Registration Page" will be displayed in the page title' do
          visit new_user_path
          find('input[name="user[name]"]').set('')
          find('input[name="user[email]"]').set('')
          find('input[name="user[password]"]').set('')
          find('input[name="user[password_confirmation]"]').set('')
          click_button 'Register'
          expect(page).to have_content 'Account registration page'
        end
        it 'If login is successful, "Task List Page" will be displayed in the page title' do
          visit new_session_path
          find('input[name="session[email]"]').set(user.email)
          find('input[name="session[password]"]').set(user.password)
          click_button 'login'
          expect(page).to have_content 'Task List Page'
        end
        it 'If login fails, "login page" will be displayed in the page title' do
          visit new_session_path
          find('input[name="session[email]"]').set('failed@email.com')
          find('input[name="session[password]"]').set('failed_password')
          click_button 'login'
          expect(page).to have_content 'login page'
        end
      end
      context 'Logging in as a regular user' do
        before do
          visit new_session_path
          find('input[name="session[email]"]').set(user.email)
          find('input[name="session[password]"]').set(user.password)
          click_button 'login'
        end
        it 'Make global navigation links transition as per requirement' do
          click_link 'account'
          expect(page).to have_content 'Account details page'
          click_link 'Logout'
          expect(page).to have_content 'Login page'
        end
        it 'When "Edit" is clicked on the account details page, "Account Edit Page" will be displayed in the page title' do
          visit user_path(user)
          click_link 'edit'
          expect(page).to have_content 'Edit account page'
        end
        it 'If the account is successfully edited, the "Account Details Page" will be displayed in the page title' do
          visit edit_user_path(user)
          find('input[name="user[name]"]').set('edit_user_name')
          find('input[name="user[email]"]').set('edit_user@email.com')
          find('input[name="user[password]"]').set('edit_password')
          find('input[name="user[password_confirmation]"]').set('edit_password')
          click_button 'update'
          expect(page).to have_content 'Account details page'
        end
        it 'If editing the account fails, "Edit Account Page" will be displayed in the page title' do
          visit edit_user_path(user)
          find('input[name="user[name]"]').set('')
          find('input[name="user[email]"]').set('')
          find('input[name="user[password]"]').set('')
          find('input[name="user[password_confirmation]"]').set('')
          click_button 'update'
          expect(page).to have_content 'Account edit page'
        end
        it "If you click 'Back' on the account edit page, the page title will show 'Account Details Page'" do
          visit edit_user_path(user)
          click_link 'Back'
          expect(page).to have_content 'Account details page'
        end
      end
      context 'When logged in as administrator' do
        before do
          visit new_session_path
          find('input[name="session[email]"]').set(admin.email)
          find('input[name="session[password]"]').set(admin.password)
          click_button 'login'
        end
        it 'Make global navigation links transition as per requirement' do
          click_link 'account'
          expect(page).to have_content 'Account details page'
          click_link 'Logout'
          expect(page).to have_content 'Login page'
        end
        it 'When "Details" is clicked on the user list page, "User Details Page" will be displayed in the page title' do
          visit admin_users_path
          click_link 'details', href: admin_user_path(user)
          expect(page).to have_content 'User details page'
        end
        it 'When "Edit" is clicked on the user list screen, "Edit User Page" will be displayed in the page title' do
          visit admin_users_path
          click_link 'edit', href: edit_admin_user_path(user)
          expect(page).to have_content 'Edit user page'
        end
        it 'When "Delete" is clicked on the user list page, "User List Page" will be displayed in the page title' do
          visit admin_users_path
          click_link 'delete', href: admin_user_path(user)
          page.driver.browser.switch_to.alert.accept
          expect(page).to have_content 'user list page'
        end
        it 'When "Back" is clicked in the user edit screen, "User List Page" will be displayed in the page title' do
          visit edit_admin_user_path(user)
          click_link 'Back'
          expect(page).to have_content 'User List Page'
        end
        it "If a user is successfully registered, 'User List Page' will be displayed in the page title" do
          visit new_admin_user_path
          find('input[name="user[name]"]').set('new_user_name')
          find('input[name="user[email]"]').set('new_user@email.com')
          find('input[name="user[password]"]').set('new_password')
          find('input[name="user[password_confirmation]"]').set('new_password')
          click_button 'Register'
          expect(page).to have_content 'User List Page'
        end
        it 'If user registration fails, "User Registration Page" will be displayed in the page title' do
          visit new_admin_user_path
          find('input[name="user[name]"]').set('')
          find('input[name="user[email]"]').set('')
          find('input[name="user[password]"]').set('')
          find('input[name="user[password_confirmation]"]').set('')
          click_button 'Register'
          expect(page).to have_content 'User registration page'
        end
        it 'If the user is successfully edited, "User List Page" will be displayed in the page title' do
          visit edit_admin_user_path(user)
          find('input[name="user[name]"]').set('edit_user_name')
          find('input[name="user[email]"]').set('edit_user@email.com')
          find('input[name="user[password]"]').set('edit_password')
          find('input[name="user[password_confirmation]"]').set('edit_password')
          click_button 'update'
          expect(page).to have_content 'User List Page'
        end
        it 'If editing a user fails, "Edit User Page" will be displayed in the page title' do
          visit edit_admin_user_path(user)
          find('input[name="user[name]"]').set('')
          find('input[name="user[email]"]').set('')
          find('input[name="user[password]"]').set('')
          find('input[name="user[password_confirmation]"]').set('')
          click_button 'update'
          expect(page).to have_content 'User edit page'
        end
      end
    end
  end

  describe 'Functional Requirements' do
    describe '9. When a user clicks on a link to delete a user, the confirmation dialog should say "Are you sure you want to delete this?" in the confirmation dialog.' do
      before do
        visit new_session_path
        find('input[name="session[email]"]').set(admin.email)
        find('input[name="session[password]"]').set(admin.password)
        click_button 'login'
      end
      it 'When a user clicks on a link to delete a user, the confirmation dialog should say "Are you sure you want to delete this?" in the confirmation dialog.' do
        visit admin_users_path
        click_link 'delete', href: admin_user_path(user)
        expect(page.driver.browser.switch_to.alert.text).to eq 'Are you sure you want to delete this?'
      end
    end

    describe '10. If validation fails for registering or editing an account, or registering or editing a user, display a validation message as per the conditions indicated in the requirements' do
      context 'Account registration screen' do
        it "Validation message if all forms are unfilled, the validation messages [Please enter your name] ,[Please enter your email address] and [Please enter your password] will be displayed." do
          visit new_user_path
          find('input[name="user[name]"]').set('')
          find('input[name="user[email]"]').set('')
          find('input[name="user[password]"]').set('')
          find('input[name="user[password_confirmation]"]').set('')
          click_button 'Register'
          expect(page).to have_content 'Please enter your name'
          expect(page).to have_content 'Please enter your email address'
          expect(page).to have_content 'Please enter your password'
        end
        it "Validation message if you enter an email address that is already in use, the validation messages [Email address is already in use] will be displayed." do
          visit new_user_path
          find('input[name="user[name]"]').set('new_user_name')
          find('input[name="user[email]"]').set(user.email)
          find('input[name="user[password]"]').set('password')
          find('input[name="user[password_confirmation]"]').set('password')
          click_button 'Register'
          expect(page).to have_content 'Email address is already in use'
        end
        it "Validation message if password is less than 6 characters, the validation messages [Please enter a password of at least 6 characters] will be displayed." do
          visit new_user_path
          find('input[name="user[name]"]').set('new_user_name')
          find('input[name="user[email]"]').set('new_user@email.com')
          find('input[name="user[password]"]').set('passw')
          find('input[name="user[password_confirmation]"]').set('passw')
          click_button 'Register'
          expect(page).to have_content 'Please enter a password of at least 6 characters'
        end
        it "Validation message if password and password (confirmation) do not match, the validation messages [Password confirmation doesn't match Password] will be displayed." do
          visit new_user_path
          find('input[name="user[name]"]').set('new_user_name')
          find('input[name="user[email]"]').set('new_user@email.com')
          find('input[name="user[password]"]').set('password')
          find('input[name="user[password_confirmation]"]').set('passwordd')
          click_button 'Register'
          expect(page).to have_content "Password confirmation doesn't match Password"
        end
      end
      context 'Account edit screen' do
        before do
          visit new_session_path
          find('input[name="session[email]"]').set(user.email)
          find('input[name="session[password]"]').set(user.password)
          click_button 'login'
        end
        it "Validation message if all forms are unfilled, the validation messages [Please enter your name], [Please enter your email address] and [Please enter your password] will be displayed." do
          visit edit_user_path(user)
          find('input[name="user[name]"]').set('')
          find('input[name="user[email]"]').set('')
          find('input[name="user[password]"]').set('')
          find('input[name="user[password_confirmation]"]').set('')
          click_button 'update'
          expect(page).to have_content 'Please enter your name'
          expect(page).to have_content 'Please enter your email address'
          expect(page).to have_content 'Please enter your password'
        end
        it "Validation message if you enter an email address that is already in use, the validation messages [Email address is already in use] will be displayed." do
          visit edit_user_path(user)
          find('input[name="user[name]"]').set('new_user_name')
          find('input[name="user[email]"]').set(admin.email)
          find('input[name="user[password]"]').set('password')
          find('input[name="user[password_confirmation]"]').set('password')
          click_button 'update'
          expect(page).to have_content 'Email address is already in use'
        end
        it "Validation message if password is less than 6 characters, the validation messages [Please enter a password of at least 6 characters] will be displayed." do
          visit edit_user_path(user)
          find('input[name="user[name]"]').set('new_user_name')
          find('input[name="user[email]"]').set('new_user@email.com')
          find('input[name="user[password]"]').set('passw')
          find('input[name="user[password_confirmation]"]').set('passw')
          click_button 'update'
          expect(page).to have_content 'Please enter a password of at least 6 characters'
        end
        it "Validation message if password and password (confirmation) do not match, the validation messages [Password confirmation doesn't match Password] will be displayed.
" do
          visit edit_user_path(user)
          find('input[name="user[name]"]').set('new_user_name')
          find('input[name="user[email]"]').set('new_user@email.com')
          find('input[name="user[password]"]').set('password')
          find('input[name="user[password_confirmation]"]').set('passwordd')
          click_button 'update'
          expect(page).to have_content "Password confirmation doesn't match Password"
        end
      end
      context 'User registration screen' do
        before do
          visit new_session_path
          find('input[name="session[email]"]').set(admin.email)
          find('input[name="session[password]"]').set(admin.password)
          click_button 'login'
        end
        it "Validation message if all forms are unfilled, the validation messages [Please enter your name] ,[Please enter your email address] and [Please enter your password] will be displayed." do
          visit new_admin_user_path
          find('input[name="user[name]"]').set('')
          find('input[name="user[email]"]').set('')
          find('input[name="user[password]"]').set('')
          find('input[name="user[password_confirmation]"]').set('')
          click_button 'Register'
          expect(page).to have_content 'Please enter your name'
          expect(page).to have_content 'Please enter your email address'
          expect(page).to have_content 'Please enter your password'
        end
        it "Validation message if you enter an email address that is already in use, the validation messages [Email address is already in use] will be displayed." do
          visit new_admin_user_path
          find('input[name="user[name]"]').set('new_user_name')
          find('input[name="user[email]"]').set(user.email)
          find('input[name="user[password]"]').set('password')
          find('input[name="user[password_confirmation]"]').set('password')
          click_button 'Register'
          expect(page).to have_content 'Email address is already in use'
        end
        it "Validation message if password is less than 6 characters, the validation messages [Please enter a password of at least 6 characters] will be displayed." do
          visit new_admin_user_path
          find('input[name="user[name]"]').set('new_user_name')
          find('input[name="user[email]"]').set('new_user@email.com')
          find('input[name="user[password]"]').set('passw')
          find('input[name="user[password_confirmation]"]').set('passw')
          click_button 'Register'
          expect(page).to have_content 'Please enter a password of at least 6 characters'
        end
        it "Validation message if password and password (confirmation) do not match, the validation messages [Password confirmation doesn't match Password] will be displayed.
" do
          visit new_admin_user_path
          find('input[name="user[name]"]').set('new_user_name')
          find('input[name="user[email]"]').set('new_user@email.com')
          find('input[name="user[password]"]').set('password')
          find('input[name="user[password_confirmation]"]').set('passwordd')
          click_button 'Register'
          expect(page).to have_content "Password confirmation doesn't match Password"
        end
      end
      context 'user edit screen' do
        before do
          visit new_session_path
          find('input[name="session[email]"]').set(admin.email)
          find('input[name="session[password]"]').set(admin.password)
          click_button 'login'
        end
        it "Validation message if all forms are unfilled, the validation messages [Please enter your name] ,[Please enter your email address] and [Please enter your password] will be displayed." do
          visit edit_admin_user_path(user)
          find('input[name="user[name]"]').set('')
          find('input[name="user[email]"]').set('')
          find('input[name="user[password]"]').set('')
          find('input[name="user[password_confirmation]"]').set('')
          click_button 'update'
          expect(page).to have_content 'Please enter your name'
          expect(page).to have_content 'Please enter your email address'
          expect(page).to have_content 'Please enter your password'
        end
        it "Validation message if you enter an email address that is already in use, the validation messages [Email address is already in use] will be displayed.
" do
          visit edit_admin_user_path(user)
          find('input[name="user[name]"]').set('new_user_name')
          find('input[name="user[email]"]').set(admin.email)
          find('input[name="user[password]"]').set('password')
          find('input[name="user[password_confirmation]"]').set('password')
          click_button 'update'
          expect(page).to have_content 'Email address is already in use'
        end
        it "Validation message if password is less than 6 characters, the validation messages [Please enter a password of at least 6 characters] will be displayed." do
          visit edit_admin_user_path(user)
          find('input[name="user[name]"]').set('new_user_name')
          find('input[name="user[email]"]').set('new_user@email.com')
          find('input[name="user[password]"]').set('passw')
          find('input[name="user[password_confirmation]"]').set('passw')
          click_button 'update'
          expect(page).to have_content 'Please enter a password of at least 6 characters'
        end
        it "Validation message if password and password (confirmation) do not match, the validation messages [Password confirmation doesn't match Password] will be displayed.
" do
          visit edit_admin_user_path(user)
          find('input[name="user[name]"]').set('new_user_name')
          find('input[name="user[email]"]').set('new_user@email.com')
          find('input[name="user[password]"]').set('password')
          find('input[name="user[password_confirmation]"]').set('passwordd')
          click_button 'update'
          expect(page).to have_content "Password confirmation doesn't match Password"
        end
      end
    end

    describe '11. To display the flash message as per the conditions indicated in the requirements.' do
      context 'If the account is successfully registered' do
        it 'To display a flash message "You have registered an account"' do
          visit new_user_path
          find('input[name="user[name]"]').set('new_user_name')
          find('input[name="user[email]"]').set('new_user@email.com')
          find('input[name="user[password]"]').set('new_password')
          find('input[name="user[password_confirmation]"]').set('new_password')
          click_button 'Register'
          expect(page).to have_content 'You have registered an account'
        end
      end
      context 'If the account is successfully updated' do
        before do
          visit new_session_path
          find('input[name="session[email]"]').set(user.email)
          find('input[name="session[password]"]').set(user.password)
          click_button 'login'
        end
        it 'To display a flash message "You have updated your account"' do
          visit edit_user_path(user)
          find('input[name="user[name]"]').set('new_user_name')
          find('input[name="user[email]"]').set('new_user@email.com')
          find('input[name="user[password]"]').set('new_password')
          find('input[name="user[password_confirmation]"]').set('new_password')
          click_button 'update'
          expect(page).to have_content 'You have updated your account'
        end
      end
      context 'If login was successful' do
        it 'To display a flash message "You are logged in"' do
          visit new_session_path
          find('input[name="session[email]"]').set(user.email)
          find('input[name="session[password]"]').set(user.password)
          click_button 'login'
          expect(page).to have_content 'You are logged in'
        end
      end
      context 'Login failed' do
        it 'To display a flash message "You have an incorrect email address or password"' do
          visit new_session_path
          find('input[name="session[email]"]').set('failed_user@email.com')
          find('input[name="session[password]"]').set('failed_password')
          click_button 'login'
          expect(page).to have_content 'You have an incorrect email address or password'
        end
      end
      context 'If you logged out' do
        before do
          visit new_session_path
          find('input[name="session[email]"]').set(user.email)
          find('input[name="session[password]"]').set(user.password)
          click_button 'login'
        end
        it 'To display a flash message saying "You are logged out"' do
          click_link 'Logout'
          expect(page).to have_content 'You are logged out'
        end
      end
      context 'If the user is successfully registered' do
        before do
          visit new_session_path
          find('input[name="session[email]"]').set(admin.email)
          find('input[name="session[password]"]').set(admin.password)
          click_button 'login'
        end
        it 'To display a flash message "You have registered a user"' do
          visit new_admin_user_path
          find('input[name="user[name]"]').set('new_user_name')
          find('input[name="user[email]"]').set('new_user@email.com')
          find('input[name="user[password]"]').set('new_password')
          find('input[name="user[password_confirmation]"]').set('new_password')
          click_button 'Register'
          expect(page).to have_content 'You have registered a user'
        end
      end
      context 'If the user is successfully updated' do
        before do
          visit new_session_path
          find('input[name="session[email]"]').set(admin.email)
          find('input[name="session[password]"]').set(admin.password)
          click_button 'login'
        end
        it 'To display a flash message "User has been updated"' do
          visit edit_admin_user_path(user)
          find('input[name="user[name]"]').set('new_user_name')
          find('input[name="user[email]"]').set('new_user@email.com')
          find('input[name="user[password]"]').set('new_password')
          find('input[name="user[password_confirmation]"]').set('new_password')
          click_button 'update'
          expect(page).to have_content 'User has been updated'
        end
      end
      context 'Deleting a user' do
        before do
          visit new_session_path
          find('input[name="session[email]"]').set(admin.email)
          find('input[name="session[password]"]').set(admin.password)
          click_button 'login'
        end
        it 'To display a flash message "User deleted"' do
          visit admin_users_path
          click_link 'delete', href: admin_user_path(user)
          page.driver.browser.switch_to.alert.accept
          expect(page).to have_content 'User deleted'
        end
      end
    end

    describe '12. Add a setting to make email addresses case-insensitive' do
      it 'When I try to register an existing email address by changing the font size, I get a validation message that [Email address is already in use]' do
        visit new_user_path
        find('input[name="user[name]"]').set('new_user_name')
        find('input[name="user[email]"]').set('User@email.com')
        find('input[name="user[password]"]').set('new_password')
        find('input[name="user[password_confirmation]"]').set('new_password')
        click_button 'Register'
        expect(page).to have_content 'Email address is already in use'
      end
    end

    describe '13. Create an association between users and tasks so that only tasks created by the user are shown in the task list screen' do
      let!(:second_user) { User.create(name: 'second_user_name', email: 'second_user@email.com', password: 'password') }
      before do
        visit new_session_path
        find('input[name="session[email]"]').set(user.email)
        find('input[name="session[password]"]').set(user.password)
        click_button 'login'
      end
      it 'To create an association between a user and a task, and to show only the tasks created by the user in the task list screen' do
        5.times do |n|
          Task.create(title: "task_title_#{n}", content: "task_content_#{n}", deadline_on: Date.today, priority: 0, status: 0, user_id: user.id)
          Task.create(title: "second_user_task_title_#{n}", content: "task_content_#{n}", deadline_on: Date.today, priority: 0, status: 0, user_id: second_user.id)
        end
        visit tasks_path
        5.times do |n|
          expect(page).to have_content "task_title_#{n}"
          expect(page).not_to have_content "second_user_task_title_#{n}"
        end
      end
    end

    describe '14. If a user accesses a page other than the login screen and account registration screen without logging in, the user should be redirected to the login page and shown a flash message "Please login"' do
      let!(:task){Task.create(title: 'task_title', content: 'task_content', deadline_on: Date.today, priority: 0, status: 0, user_id: user.id)}
      it 'When you access the task list screen' do
        visit tasks_path
        expect(current_path).to eq new_session_path
        expect(page).to have_content 'Please login'
      end
      it 'If you access the task details screen' do
        visit task_path(task)
        expect(current_path).to eq new_session_path
        expect(page).to have_content 'Please login'
      end
      it 'If you access the task edit screen' do
        visit edit_task_path(task)
        expect(current_path).to eq new_session_path
        expect(page).to have_content 'Please login'
      end
      it 'If you access the account details screen' do
        visit user_path(user)
        expect(current_path).to eq new_session_path
        expect(page).to have_content 'Please login'
      end
      it 'If you access the edit account page' do
        visit edit_user_path(user)
        expect(current_path).to eq new_session_path
        expect(page).to have_content 'Please login'
      end
      it 'If you access the user list screen' do
        visit admin_users_path
        expect(current_path).to eq new_session_path
        expect(page).to have_content 'Please login'
      end
      it 'If you access the user registration page' do
        visit new_admin_user_path
        expect(current_path).to eq new_session_path
        expect(page).to have_content 'Please login'
      end
      it 'If you access the user details page' do
        visit admin_user_path(user)
        expect(current_path).to eq new_session_path
        expect(page).to have_content 'Please login'
      end
      it 'If you access the user edit screen' do
        visit edit_admin_user_path(user)
        expect(current_path).to eq new_session_path
        expect(page).to have_content 'Please login'
      end
    end

    describe '15. If you access the login screen or account registration screen while logged in, you should be taken to the task list screen and shown a flash message "Please log out"' do
      before do
        visit new_session_path
        find('input[name="session[email]"]').set(admin.email)
        find('input[name="session[password]"]').set(admin.password)
        click_button 'login'
      end
      it 'If you access the login screen' do
        visit new_session_path
        expect(current_path).not_to eq new_session_path
        expect(page).to have_content 'Please logout'
      end
      it 'If you have accessed the account registration page' do
        visit new_user_path
        expect(current_path).not_to eq new_user_path
        expect(page).to have_content 'Please logout'
      end
    end

    describe "16. When someone tries to access another person's task detail screen or task edit screen, the user will be redirected to the task list screen with a flash message that says 'Only the user can access'" do
      let!(:second_user) { User.create(name: 'second_user_name', email: 'second_user@email.com', password: 'password') }
      let!(:second_user_task){ Task.create(title: 'task_title', content: 'task_content', deadline_on: Date.today, priority: 0, status: 0, user_id: second_user.id)}
      before do
        visit new_session_path
        find('input[name="session[email]"]').set(user.email)
        find('input[name="session[password]"]').set(user.password)
        click_button 'login'
      end
      it 'If you access the task details screen' do
        visit task_path(second_user_task)
        expect(current_path).to eq tasks_path
        expect(page).to have_content 'Only you can access this page'
      end
      it 'If you access the task edit screen' do
        visit edit_task_path(second_user_task)
        expect(current_path).to eq tasks_path
        expect(page).to have_content 'Only you can access this page'
      end
    end

    describe '17. When a user is deleted, all tasks associated with that user will be deleted' do
      before do
        visit new_session_path
        find('input[name="session[email]"]').set(admin.email)
        find('input[name="session[password]"]').set(admin.password)
        click_button 'login'
      end
      it 'When a user is deleted, all tasks associated with that user will be deleted' do
        10.times do
          Task.create(title: 'task_title', content: 'task_content', deadline_on: Date.today, priority: 0, status: 0, user_id: user.id)
        end
        visit admin_users_path
        click_link 'delete', href: admin_user_path(user)
        page.driver.browser.switch_to.alert.accept
        sleep 0.5
        expect(Task.all.count).to eq 0
      end
    end

    describe '18. The ability to add and remove admin rights on the user registration and edit screens' do
      let!(:second_admin) { User.create(name: 'second_admin_name', email: 'second_admin@email.com', password: 'password', admin: true) }
      before do
        visit new_session_path
        find('input[name="session[email]"]').set(admin.email)
        find('input[name="session[password]"]').set(admin.password)
        click_button 'login'
      end
      it 'The ability to add or remove admin rights on the user registration screen' do
        visit new_admin_user_path
        find('input[name="user[name]"]').set('new_user_name')
        find('input[name="user[email]"]').set('new_user@email.com')
        find('input[name="user[password]"]').set('password')
        find('input[name="user[password_confirmation]"]').set('password')
        check 'user[admin]'
        click_button 'register'
        expect(User.find_by(email: 'new_user@email.com').admin).to eq true
      end
      it "The ability to add and remove admin rights on the user's edit screen" do
        visit edit_admin_user_path(second_admin)
        find('input[name="user[name]"]').set('new_user_name')
        find('input[name="user[email]"]').set('new_user@email.com')
        find('input[name="user[password]"]').set('password')
        find('input[name="user[password_confirmation]"]').set('password')
        uncheck 'user[admin]'
        click_button 'update'
        expect(User.find_by(email: 'new_user@email.com').admin).to eq false
      end
    end

    describe '19. When a regular user accesses the administration screen (one of the four newly created screens), the user should be redirected to the task list screen and shown a flash message "Only administrator can access"' do
      before do
        visit new_session_path
        find('input[name="session[email]"]').set(user.email)
        find('input[name="session[password]"]').set(user.password)
        click_button 'login'
      end
      it 'When the user list screen is accessed, the user should be redirected to the task list screen and a flash message "Only administrators can access this page" should be displayed' do
        visit admin_users_path
        expect(current_path).to eq tasks_path
        expect(page).to have_content 'Only administrators can access this page'
      end
      it 'When the user registration screen is accessed, the user will be redirected to the task list screen and a flash message "Only administrators can access this page" will be displayed' do
        visit new_admin_user_path
        expect(current_path).to eq tasks_path
        expect(page).to have_content 'Only administrators can access this page'
      end
      it 'When the user details screen is accessed, the user will be redirected to the task list screen and a flash message "Only administrators can access this page" will be displayed' do
        visit admin_user_path(user)
        expect(current_path).to eq tasks_path
        expect(page).to have_content 'Only administrators can access this page'
      end
      it 'When the user edit screen is accessed, the user will be redirected to the task list screen and a flash message "Only administrators can access this page" will be displayed' do
        visit edit_admin_user_path(user)
        expect(current_path).to eq tasks_path
        expect(page).to have_content 'Only administrators can access this page'
      end
    end

    describe '20. If there is only one administrator and you try to delete the user, use the model callback to control the deletion and display a flash message "Cannot delete because there are zero accounts with admin rights"' do
      before do
        visit new_session_path
        find('input[name="session[email]"]').set(admin.email)
        find('input[name="session[password]"]').set(admin.password)
        click_button 'login'
      end
      it "If there is only one administrator and you try to delete the user, use the model callback to control that the user cannot be deleted and display the flash message [Cannot delete because there are zero accounts with admin rights]" do
        visit admin_users_path
        click_link 'delete', href: admin_user_path(admin)
        page.driver.browser.switch_to.alert.accept
        expect(page).to have_content 'Cannot delete because there are zero accounts with admin rights'
      end
    end

    describe '21. If there is only one administrator and an update is attempted to remove admin rights from that user, use the model callback to control that update cannot be done and display the error message "Cannot update because there are zero accounts with admin rights"' do
      before do
        visit new_session_path
        find('input[name="session[email]"]').set(admin.email)
        find('input[name="session[password]"]').set(admin.password)
        click_button 'login'
      end
      it 'To control that if there is only one administrator and an update is attempted to remove administrative privileges from that user, the model callback will be used to prevent the update and display the error message "Cannot update because there are zero accounts with administrative privileges"' do
        visit edit_admin_user_path(admin)
        find('input[name="user[name]"]').set(admin.name)
        find('input[name="user[email]"]').set(admin.email)
        find('input[name="user[password]"]').set(admin.password)
        find('input[name="user[password_confirmation]"]').set(admin.password)
        uncheck 'user[admin]'
        click_button 'update'
        expect(page).to have_content 'Cannot update because there are zero accounts with administrative privileges'
      end
    end
  end
end
