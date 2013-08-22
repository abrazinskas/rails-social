require 'spec_helper'

describe "Static pages" do
  subject{ page }




  describe "for signed-in users" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum")
      FactoryGirl.create(:micropost, user: user, content: "Dolor sit amet")
      sign_in user
      visit root_path
    end

    it "should render the user's feed" do
      user.feed.each do |item|
        page.should have_selector("li##{item.id}", text: item.content)
      end
    end

    describe "follower/following counts" do
      let(:other_user) { FactoryGirl.create(:user) }
      before do
        other_user.follow!(user)
        visit root_path
      end
      it { should have_link("0 following", href: following_user_path(user)) }
      it { should have_link("1 followers", href: followers_user_path(user)) }
    end
  end


  describe "Home page" do
    before {visit root_path }

    it { should have_selector('h1', text: 'Sample App') }
    #it "should have the title 'Home'" do
    #  visit root_path
    #  #page.should have_content('Home')
    #  expect(page).to have_title "Home"
    #end

    it { expect have_title(full_title('')) }

    it {!expect have_title(full_title('Home')) }

  end




  describe "Help page" do

    before{visit help_path}

    it { should have_selector('h1', :text => 'Help') }

    it{ expect have_title(full_title('Help')) }

    end

  describe "About page" do

    before{visit about_path}

    it{should have_selector('h1', :text => 'About Us')}

    it { expect have_title(full_title('About us'))}

  end

  describe "Contact page" do

    before{visit contact_path}

    it { expect have_title(full_title('Contact')) }

  end

  it "should have the right links on the layout" do

    visit root_path

    click_link "About"
    expect have_title(full_title('About Us'))

    click_link "Help"
    expect have_title (full_title('Help'))

    click_link "Contact"
    expect have_title (full_title('Contact'))

    click_link "Home"
    click_link "Sign up now!"
    expect have_title (full_title('Sign up'))

    click_link "sample app"
    expect  have_title (full_title(''))

  end

end