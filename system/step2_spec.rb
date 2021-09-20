require 'rails_helper'

RSpec.describe 'step2', type: :system do

  describe '開発要件' do
    let!(:task) { Task.create(title: 'task_title', content: 'task_content') }
    describe '1.i18nを使って要件通りに文字やリンク、ボタンを国際化すること' do
      it 'グローバルナビゲーション' do
        visit root_path
        expect(page).to have_selector '#tasks-index', text: 'タスク一覧'
        expect(page).to have_selector '#new-task', text: 'タスクを登録する'
      end
      it 'タスク一覧画面' do
        visit tasks_path
        find('.destroy-task').click
        sleep 0.5
        expect(page.driver.browser.switch_to.alert.text).to eq '本当に削除してもよろしいですか？'
      end
      it 'タスク登録画面' do
        visit new_task_path
        expect(page).to have_content 'タスク登録ページ'
        expect(page).to have_selector 'label', text: 'タイトル'
        expect(page).to have_selector 'label', text: '内容'
        expect(page).to have_button '登録する'
        expect(page).to have_selector '#back', text: '戻る'
      end
      it 'タスク詳細画面' do
        visit task_path(task)
        expect(page).to have_content 'タスク詳細ページ'
        expect(page).to have_content 'タイトル'
        expect(page).to have_content '内容'
        expect(page).to have_selector '#edit-task', text: '編集'
        expect(page).to have_selector '#back', text: '戻る'
      end
      it 'タスク編集画面' do
        visit edit_task_path(task)
        expect(page).to have_content 'タスク編集ページ'
        expect(page).to have_content 'タイトル'
        expect(page).to have_content '内容'
        expect(page).to have_button '更新する'
        expect(page).to have_selector '#back', text: '戻る'
      end
      context 'バリデーションメッセージ' do
        it 'タスク登録画面でタイトルと内容が未入力の場合' do
          visit new_task_path
          find('input[name="task[title]"]').set('')
          find('textarea[name="task[content]"]').set('')
          find('#create-task').click
          expect(page).to have_content "タイトルを入力してください"
          expect(page).to have_content "内容を入力してください"
        end
        it 'タスク編集画面でタイトルと内容が未入力の場合' do
          visit edit_task_path(task)
          find('input[name="task[title]"]').set('')
          find('textarea[name="task[content]"]').set('')
          find('#update-task').click
          expect(page).to have_content "タイトルを入力してください"
          expect(page).to have_content "内容を入力してください"
        end
      end
      context 'フラッシュメッセージ' do
        it 'タスクの登録に成功した場合' do
          visit new_task_path
          fill_in 'タイトル', with: 'sample title'
          fill_in '内容', with: 'sample content'
          click_button '登録する'
          expect(page).to have_content "タスクを登録しました"
        end
        it 'タスクの更新に成功した場合' do
          visit edit_task_path(task)
          fill_in 'タイトル', with: 'update sample title'
          fill_in '内容', with: 'update sample content'
          click_button '更新する'
          expect(page).to have_content "タスクを更新しました"
        end
        it 'タスクを削除した場合' do
          visit tasks_path
          click_link '削除'
          page.driver.browser.switch_to.alert.accept
          sleep 0.5
          expect(page).to have_content 'タスクを削除しました'
        end
      end
    end
    describe '2.タスク一覧画面に表示させる作成日時を、あなたの住んでいる地域の時刻に設定すること' do
      it 'タスク一覧画面に「UTC」の文字が表示されていないこと' do
        visit tasks_path
        expect(page).not_to have_content "UTC"
      end
    end
    describe '3.データベースのデータを読み書きする際の時刻を、あなたの住んでいる地域の時刻に設定すること' do
      it 'created_atカラムに「+0900」が表示されること' do
        task = Task.create(title: 'task_title', content: 'task_content')
        expect(task.created_at.to_s).to include('+0900')
      end
    end
  end

  describe '機能要件' do
    before do
      50.times do |n|
        Task.create(title: "task_title_#{n+1}", content: "task_content_#{n+1}")
      end
    end
    describe '4.タスク一覧画面でタスクを作成日時の降順で表示させること' do
      it 'タスク一覧画面でタスクを作成日時の降順で表示させること' do
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
    describe '5.kaminariのgemを使って、タスク一覧画面にページネーションを実装し、1ページあたり10件のタスクを表示させること' do
      it 'タスク一覧画面にkaminariを適用させた際に作られるpaginationクラスが存在すること' do
        visit tasks_path
        expect(page).to have_css '.pagination'
      end
      it '1ページあたり10件のタスクを表示させること' do
        visit tasks_path
        tasks = all('tbody tr')
        expect(tasks.count()).to eq 10
      end
    end
  end
end
