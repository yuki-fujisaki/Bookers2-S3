class SearchesController < ApplicationController
  before_action :authenticate_user!
  def search
    @range = params[:range]
    search = params[:search]
    @word = params[:word]

    if @range == '1'
      @books = Book.search(search,@word)
    else
      @users = User.search(search,@word)
    end
  end

  def search_tag
    @tag = params[:tag]
    @books = Book.where("tag LIKE?", "#{@tag}")
  end
end
