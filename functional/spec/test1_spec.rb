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
  	expect(caption.text).to eq('THAT FEELING WHEN YOU USE SOLANO CI WITH AWS CODEPIPELINE')
  end

end
