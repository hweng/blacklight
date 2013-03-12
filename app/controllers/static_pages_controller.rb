class StaticPagesController < ApplicationController
  def about
  	add_breadcrumb "ABOUT", ""
  end

  def faq
  	add_breadcrumb "FAQ", ""
  end

  def DOV
  	add_breadcrumb "DOV", ""
  end
end
