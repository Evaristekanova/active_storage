class Api::V1::ArticlesController < ApplicationController
    skip_before_action :verify_authenticity_token
    
    def index
        @posts = Post.all
        render json: @posts, status: :ok
    end

    def show
        begin
            @post = Post.find(params[:id])
            render json: @post, status: :ok
        rescue ActiveRecord::RecordNotFound
            render json: { error: "Article not found" }, status: :not_found
        end
    end

    def create
        @post = Post.create(article_params)

        if params[:image].present?
            response = Cloudinary::Uploader.upload(params[:image])
            @post.image_url = response['secure_url']
            puts @post.image_url
        end

        if @post.save
            render json: { success: true, post: @post, image_url: @post.image_url }, status: :ok
        else
            render json: { success: false, errors: @post.errors }, status: :unprocessable_entity
        end
    end

    def update
        begin
            @post = Post.find(params[:id])
            @post.update(article_params)
            render json: @post, status: :ok
        rescue ActiveRecord::RecordNotFound
            render json: { error: "Article not found" }, status: :not_found
        end
    end

    def destroy
        begin
            @post = Post.find(params[:id])
            @post.destroy
            render json: { success: "Article deleted" }, status: :ok
        rescue ActiveRecord::RecordNotFound
            render json: { error: "Article not found" }, status: :not_found
        end
    end

    private

    def article_params
        params.permit(:title, :content)
    end
end
