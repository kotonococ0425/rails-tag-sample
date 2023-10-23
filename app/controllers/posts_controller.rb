class PostsController < ApplicationController
  before_action :set_post, only: %i[ show edit update destroy ]

  # GET /posts
  def index
    @posts = Post.all
  end

  # GET /posts/1
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
    @tag_name = @post.tags.pluck(:name).join(",")
  end

  # POST /posts
  def create
    @post = Post.new(post_params)
    # 1. カンマ区切りの文字列を配列にする
    tag_names = params[:tag_name].split(",")
    # 2. タグ名の配列をタグの配列にする
    tags = tag_names.map { |tag_name| Tag.find_or_initialize_by(name: tag_name) }
    # 3. タグのバリデーションを行い、バリデーションエラーがあればPostのエラーに加える
    tags.each do |tag|
      if tag.invalid?
        @tag_name = params[:tag_name]
        @post.errors.add(:tags, tag.errors.full_messages.join("\n"))
        return render :edit, status: :unprocessable_entity
      end
    end

    @post.tags = tags
    if @post.save
      redirect_to @post, notice: "Post was successfully created."
    else
      @tag_name = params[:tag_name]
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /posts/1
  def update
    # 1. カンマ区切りの文字列を配列にする
    tag_names = params[:tag_name].split(",")
    # 2. タグ名の配列をタグの配列にする
    tags = tag_names.map { |tag_name| Tag.find_or_create_by(name: tag_name) }
    # 3. タグのバリデーションを行い、バリデーションエラーがあればPostのエラーに加える
    tags.each do |tag|
      if tag.invalid?
        @tag_name = params[:tag_name]
        @post.errors.add(:tags, tag.errors.full_messages.join("\n"))
        return render :edit, status: :unprocessable_entity
      end
    end

    if @post.update(post_params) && @post.update!(tags: tags)
      redirect_to @post, notice: "Post was successfully updated.", status: :see_other
    else
      @tag_name = params[:tag_name]
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /posts/1
  def destroy
    @post.destroy!
    redirect_to posts_url, notice: "Post was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.require(:post).permit(:content)
    end
end
