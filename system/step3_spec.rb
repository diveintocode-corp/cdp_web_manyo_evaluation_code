require 'rails_helper'

RSpec.describe 'step3', type: :system do

  date_list = ["2025/10/01", "2025/12/01", "2025/01/01", "2025/05/01", "2025/03/01", "2025/11/01", "2025/02/01", "2025/09/01", "2025/04/01", "2025/01/01"]
  priority_list = [2, 0, 2, 1, 1, 1, 0, 1, 1, 2, 1, 2]
  status_list = [0, 2, 2, 0, 1, 1, 0, 2, 1, 2]
  10.times { |n| let!(:"task_#{n+2}") { Task.create(created_at: Date.today+n, title: "task_title_#{n+2}", content: "task_content_#{n+2}", deadline_on: date_list[n], priority: priority_list[n], status: status_list[n]) } }

  describe 'Basic requirements' do
    describe '1. The deadline input form should be implemented using date_field' do
      it 'Registration screen' do
        visit new_task_path
        expect(find('input[type="date"]')).to be_visible
      end
      it 'edit screen' do
        visit edit_task_path(task_2)
        expect(find('input[type="date"]')).to be_visible
      end
    end
    describe "2. use select for the priority input form and allow the user to select from 'high', 'medium', and 'low'" do
      it 'registration screen' do
        visit new_task_path
        expect(find('select[name="task[priority]"]')).to be_visible
        select 'high', from: 'task[priority]'
        select 'medium', from: 'task[priority]'
        select 'low', from: 'task[priority]'
      end
      it 'edit screen' do
        visit edit_task_path(task_2)
        expect(find('select[name="task[priority]"]')).to be_visible
        select 'high', from: 'task[priority]'
        select 'medium', from: 'task[priority]'
        select 'low', from: 'task[priority]'
      end
    end
    describe "3. Use `select` for the status entry form, and allow users to select from 'not started', 'in progress', and 'completed'" do
      it 'registration screen' do
        visit new_task_path
        expect(find('select[name="task[priority]"]')).to be_visible
        select 'high', from: 'task[priority]'
        select 'medium', from: 'task[priority]'
        select 'low', from: 'task[priority]'
      end
      it 'edit screen' do
        visit edit_task_path(task_2)
        expect(find('select[name="task[priority]"]')).to be_visible
        select 'high', from: 'task[priority]'
        select 'medium', from: 'task[priority]'
        select 'low', from: 'task[priority]'
      end
    end
    describe '4. The default values for the priority and status entry forms in the task registration screen should be blank' do
      it 'The default value of the priority input form should be blank' do
        visit new_task_path
        expect(find('select[name="task[priority]"]').all('option')[0].text).to be_blank
      end
      it 'The default value of the status entry form must be blank' do
        visit new_task_path
        expect(find('select[name="task[status]"]').all('option')[0].text).to be_blank
      end
    end
    describe '5. Use form_with to implement the search function and set scope: :search' do
      it 'form tag must be present' do
        visit tasks_path
        expect(find('form')).to be_visible
      end
      it 'The name attribute of the status search form must be set to search[status]' do
        visit tasks_path
        expect(find('select[name="search[status]"]')).to be_visible
      end
    end
    describe '6. The status search form should use select and allow the user to select from "Not Started", "Started", and "Completed"' do
      it "should be able to select 'Not Started', 'In Process', or 'Completed' from the select box" do
        visit tasks_path
        select 'Not Started', from: 'search[status]'
        select 'in progress', from: 'search[status]'
        select 'Completed', from: 'search[status]'
      end
    end
    describe '7. The default value of the search form for status should be blank' do
      it 'The default value for the status search form should be blank' do
        visit tasks_path
        expect(find('select')).to be_visible
        expect(all('option')[0].text).to be_blank
      end
    end
  end

  describe 'Screen design requirements' do
    describe '8. The button to perform a search shall display the word "search" and have an HTML id attribute called `search_task`' do
      it 'To display the word "search" on the button to perform a search and to give it an HTML id attribute of `search_task`' do
        visit tasks_path
        expect(page).to have_button 'search'
        expect(page).to have_css '#search_task'
      end
    end
    describe '9. Adding an item to the table header of the list screen with the words "End Due", "Priority", and "Status"' do
      it 'list screen' do
        visit tasks_path
        expect(find("thead")).to have_content 'End due'
        expect(find("thead")).to have_content 'priority'
        expect(find("thead")).to have_content 'status'
      end
    end
    describe '10. Adding "Due Date", "Priority", and "Status" items to the task detail screen' do
      it 'List screen' do
        visit task_path(task_2)
        expect(page).to have_content 'End due'
        expect(page).to have_content 'Priority'
        expect(page).to have_content 'status'
      end
    end
    describe '11. Task priority should be displayed as "high", "medium", and "low"' do
      it 'list screen' do
        visit tasks_path
        expect(page).to have_content 'high'
        expect(page).to have_content 'medium'
        expect(page).to have_content 'low'
      end
      it 'detail screen' do
        visit task_path(task_7)
        expect(page).to have_content 'Low'
        visit task_path(task_8)
        expect(page).to have_content 'medium'
        visit task_path(task_9)
        expect(page).to have_content 'high'
      end
    end
    describe '12. Task status should be displayed as "Not Started", "In Process", or "Completed"' do
      it 'List screen' do
        visit tasks_path
        expect(page).to have_content 'Not Started'
        expect(page).to have_content 'Work in progress'
        expect(page).to have_content 'Completed'
      end
      it 'detail screen' do
        visit task_path(task_8)
        expect(page).to have_content 'Not started'
        visit task_path(task_10)
        expect(page).to have_content 'Work in progress'
        visit task_path(task_11)
        expect(page).to have_content 'Completed'
      end
    end
    describe '13. To display the words "End Due" on the form label to register the end due date' do
      it 'registration screen' do
        visit new_task_path
        expect(page).to have_selector 'label', text: 'End due'
      end
      it 'edit screen' do
        visit edit_task_path(task_2)
        expect(page).to have_selector 'label', text: 'End due'
      end
    end
    describe "14. To display the word 'priority' on the form label to register priority" do
      it 'registration screen' do
        visit new_task_path
        expect(page).to have_selector 'label', text: 'priority'
      end
      it 'edit screen' do
        visit edit_task_path(task_2)
        expect(page).to have_selector 'label', text: 'priority'
      end
    end
    describe "15. To display the word 'status' in the form label to register status" do
      it 'registration screen' do
        visit new_task_path
        expect(page).to have_selector 'label', text: 'status'
      end
      it 'edit screen' do
        visit edit_task_path(task_2)
        expect(page).to have_selector 'label', text: 'status'
      end
    end
    describe "16. To display the word 'status' in the form label of status search" do
      it "To display the word 'status' in the form label of status search" do
        visit tasks_path
        expect(page).to have_selector 'label', text: 'title'
      end
    end
    describe "17. display the text 'title' in the form label of fuzzy search" do
      it "To display the text 'title' in the form label of fuzzy search" do
        visit tasks_path
        expect(page).to have_selector 'label', text: 'status'
      end
    end
  end

  describe 'Functional requirements' do
    describe '18. To be able to register the due date, priority, and status when registering or editing a task' do
      context 'Registration screen' do
        it 'can register a due date, priority "high", and status "not started"' do
          visit new_task_path
          find('input[name="task[title]"]').set('task_title')
          find('textarea[name="task[content]"]').set('task_content')
          find('input[name="task[deadline_on]"]').set(Date.today)
          select 'high', from: 'task[priority]'
          select 'not started', from: 'task[status]'
          click_button 'register'
          expect(page).to have_content 'task_title'
          expect(page).to have_content 'task_content'
          expect(page).to have_content 'high'
          expect(page).to have_content 'not started'
        end
        it "can register an end due date, priority 'medium', and status 'in progress'" do
          visit new_task_path
          find('input[name="task[title]"]').set('task_title')
          find('textarea[name="task[content]"]').set('task_content')
          find('input[name="task[deadline_on]"]').set(Date.today.next_day)
          select 'in', from: 'task[priority]'
          select 'in progress', from: 'task[status]'
          click_button 'register'
          expect(page).to have_content 'task_title'
          expect(page).to have_content 'task_content'
          expect(page).to have_content 'middle'
          expect(page).to have_content 'in progress'
        end
        it "can register an end due date, priority 'low' and status 'complete'" do
          visit new_task_path
          find('input[name="task[title]"]').set('task_title')
          find('textarea[name="task[content]"]').set('task_content')
          find('input[name="task[deadline_on]"]').set(Date.today.next_month)
          select 'high', from: 'task[priority]'
          select 'not started', from: 'task[status]'
          click_button 'register'
          expect(page).to have_content 'task_title'
          expect(page).to have_content 'task_content'
          expect(page).to have_content 'high'
          expect(page).to have_content 'not started'
        end
      end
      context 'edit screen' do
        it "can be updated to a different due date, priority 'high', status 'not started'" do
          visit edit_task_path(task_2)
          find('input[name="task[deadline_on]"]]').set(Date.today.next_day)
          select 'high', from: 'task[priority]'
          select 'not started', from: 'task[status]'
          click_button 'update'
          expect(page).to have_content 'task_title'
          expect(page).to have_content 'task_content'
          expect(page).to have_content 'high'
          expect(page).to have_content 'not started'
        end
        it "can be updated to a different end due date, priority 'medium', status 'in progress'" do
          visit edit_task_path(task_2)
          find('input[name="task[deadline_on]"]]').set(Date.today.next_month)
          select 'in', from: 'task[priority]'
          select 'in progress', from: 'task[status]'
          click_button 'update'
          expect(page).to have_content 'task_title'
          expect(page).to have_content 'task_content'
          expect(page).to have_content 'middle'
          expect(page).to have_content 'in progress'
        end
        it "can be updated to a different finish deadline, priority 'low', status 'complete'" do
          visit edit_task_path(task_2)
          find('input[name="task[deadline_on]"]]').set(Date.today.next_year)
          select 'high', from: 'task[priority]'
          select 'not started', from: 'task[status]'
          click_button 'update'
          expect(page).to have_content 'task_title'
          expect(page).to have_content 'task_content'
          expect(page).to have_content 'high'
          expect(page).to have_content 'not started'
        end
      end
    end
    describe '19. Adding validation as per requirement in task registration and editing' do
      it 'registration screen' do
        visit new_task_path
        find('input[name="task[title]"]').set('task_title')
        find('textarea[name="task[content]"]').set('task_content')
        find('input[name="task[deadline_on]"]').set('')
        select '', from: 'task[priority]'
        select '', from: 'task[status]'
        click_button 'register'
        expect(page).to have_content 'Please enter an end due date'
        expect(page).to have_content 'Please enter a priority'
        expect(page).to have_content 'Please enter a status'
      end
      it 'edit screen' do
        visit edit_task_path(task_2)
        find('input[name="task[deadline_on]"]]').set(nil)
        click_button 'update'
        expect(page).to have_content 'Please enter an end deadline'
      end
    end
    describe "20. When clicking on 'Due Date' in the table header, the tasks should be sorted in ascending order by due date, and if they have the same due date, they should be displayed in descending order by creation date." do
      it "When you click on 'Due Date' in the table header, sort the tasks in ascending order by due date, and if they have the same due date, display them in descending order by creation date" do
        visit tasks_path
        click_on 'end_date'
        sleep 0.2
        tr = all('tbody tr')
        expect(tr[0].text).to have_content 'task_title_11'
        expect(tr[1].text).to have_content 'task_title_4'
        expect(tr[2].text).to have_content 'task_title_8'
        expect(tr[3].text).to have_content 'task_title_6'
        expect(tr[4].text).to have_content 'task_title_10'
        expect(tr[5].text).to have_content 'task_title_5'
        expect(tr[6].text).to have_content 'task_title_9'
        expect(tr[7].text).to have_content 'task_title_2'
        expect(tr[8].text).to have_content 'task_title_7'
        expect(tr[9].text).to have_content 'task_title_3'
      end
    end
    describe '21. When clicking on "Priority" in the table header, sort in order of priority, and if the priorities are the same, display in descending order of creation date and time' do
      it 'When clicking on "Priority" in the table header, sort in order of priority, and if the priorities are the same, display in descending order of creation date and time' do
        visit tasks_path
        click_on 'priority'
        sleep 0.2
        tr = all('tbody tr')
        expect(tr[0].text).to have_content 'task_title_11'
        expect(tr[1].text).to have_content 'task_title_9'
        expect(tr[2].text).to have_content 'task_title_4'
        expect(tr[3].text).to have_content 'task_title_2'
        expect(tr[4].text).to have_content 'task_title_10'
        expect(tr[5].text).to have_content 'task_title_8'
        expect(tr[6].text).to have_content 'task_title_6'
        expect(tr[7].text).to have_content 'task_title_5'
        expect(tr[8].text).to have_content 'task_title_7'
        expect(tr[9].text).to have_content 'task_title_3'
      end
    end
    describe "22. Implement a function to search by status 'not started', 'in progress', or 'completed' in the list screen" do
      it 'can search by "not started"' do
        visit tasks_path
        select 'Not Started', from: "search[status]"
        find('#search_task').click
        expect(page).to have_content 'task_title_2'
        expect(page).to have_content 'task_title_5'
        expect(page).to have_content 'task_title_8'
        expect(page).not_to_have_content 'task_title_3'
        expect(page).not_to have_content 'task_title_4'
        expect(page).not_to have_content 'task_title_6'
        expect(page).not_to have_content 'task_title_7'
        expect(page).not_to have_content 'task_title_9'
        expect(page).not_to have_content 'task_title_10'
        expect(page).not_to have_content 'task_title_11'
      end
      it 'can be search by  "in progress"' do
        visit tasks_path
        select 'in progress', from: "search[status]"
        find('#search_task').click
        expect(page).to have_content 'task_title_6'
        expect(page).to have_content 'task_title_7'
        expect(page).to have_content 'task_title_10'
        expect(page).not_to_have_content 'task_title_2'
        expect(page).not_to have_content 'task_title_3'
        expect(page).not_to have_content 'task_title_4'
        expect(page).not_to have_content 'task_title_5'
        expect(page).not_to have_content 'task_title_8'
        expect(page).not_to have_content 'task_title_9'
        expect(page).not_to have_content 'task_title_11'
      end
      it 'can be search by "completed"' do
        visit tasks_path
        select 'completion', from: "search[status]"
        find('#search_task').click
        expect(page).to have_content 'task_title_3'
        expect(page).to have_content 'task_title_4'
        expect(page).to have_content 'task_title_9'
        expect(page).to have_content 'task_title_11'
        expect(page).not_to_have_content 'task_title_2'
        expect(page).not_to have_content 'task_title_5'
        expect(page).not_to have_content 'task_title_6'
        expect(page).not_to have_content 'task_title_7'
        expect(page).not_to have_content 'task_title_8'
        expect(page).not_to have_content 'task_title_10'
      end
    end
    describe '23. Implement a fuzzy search function by title in the list screen' do
      it 'Implement fuzzy search function by title in the list screen' do
        visit tasks_path
        find('input[name="search[title]"]').set('task_title_1')
        find('#search_task').click
        expect(page).to have_content 'task_title_10'
        expect(page).to have_content 'task_title_11'
        expect(page).not_to_have_content 'task_title_2'
        expect(page).not_to have_content 'task_title_3'
        expect(page).not_to have_content 'task_title_4'
        expect(page).not_to have_content 'task_title_5'
        expect(page).not_to have_content 'task_title_6'
        expect(page).not_to have_content 'task_title_7'
        expect(page).not_to have_content 'task_title_8'
        expect(page).not_to have_content 'task_title_9'
      end
    end
    describe '24. The search function should be able to refine the search by both title and status' do
      it 'The search function should be able to refine the search by both title and status' do
        visit tasks_path
        select 'in progress', from: "search[status]"
        find('input[name="search[title]"]').set('task_title_1')
        find('#search_task').click
        expect(page).to have_content 'task_title_10'
        expect(page).not_to_have_content 'task_title_2'
        expect(page).not_to have_content 'task_title_3'
        expect(page).not_to have_content 'task_title_4'
        expect(page).not_to have_content 'task_title_5'
        expect(page).not_to have_content 'task_title_6'
        expect(page).not_to have_content 'task_title_7'
        expect(page).not_to have_content 'task_title_8'
        expect(page).not_to have_content 'task_title_9'
        expect(page).not_to have_content 'task_title_11'
      end
    end
  end
end
