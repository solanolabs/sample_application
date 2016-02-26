require_relative "../util/spec_helper"

describe "Webpage sample for Solano + Sauce" do
  it "should have meme" do
  	@browser.get "http://localhost:8000"
  	meme = @browser.find_element(:class => 'sl-meme')
  	expect(meme.displayed?).to be true
  end

  it "should see caption" do
  	@browser.get "http://localhost:8000"
  	caption = @browser.find_element(:class => 'caption')
  	expect(caption.displayed?).to be true
  	expect(caption.text).to eq("THAT FEELING WHEN YOU'RE DEPLOYING CONTINUOUSLY")
  end

  it "should have a link in the caption" do
  	@browser.get "http://localhost:8000"
  	link = @browser.find_element(:class => 'caption').attribute('href')
    expect(link).not_to include("_placeholder_")
  end
end
