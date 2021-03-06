class ArtworksController < ApplicationController
    def index
        if params.has_key?(:user_id)
            # index of nested resource

            # combine artworks of user with artworks shared with user
            @artworks = Artwork.find_by_sql(<<-SQL)
                SELECT artworks.id, title, image_url, artist_id 
                FROM artworks 
                JOIN artwork_shares ON artwork_id = artworks.id 
                WHERE viewer_id = #{params[:user_id]}

                UNION 

                SELECT * 
                FROM artworks 
                WHERE artist_id = #{params[:user_id]}             
            SQL
            # side note: couldn't figure out how to use ? or a symbol like :user_id 
            # in the heredoc with the arguments at the top
            
            # p 'nested'

        else
            # index of top-level resource
            # p 'not nested'
            @artworks = Artwork.all
        end

        render json: @artworks
    end

    def show
        @artwork = Artwork.find(params[:id])

        render json: @artwork
    end

    def create
        @artwork = Artwork.new(artwork_params)
        
        if @artwork.save
            redirect_to artwork_url(@artwork)
        else
            render json: @artwork.error.full_messages, status: 422
        end
    end

    def update
        @artwork = Artwork.find(params[:id])

        if @artwork.update(artwork_params)
            redirect_to artwork_url(@artwork)
        else
            render json: @artwork.error.full_messages, status: 422
        end
    end

    def destroy
        @artwork = Artwork.find(params[:id])
        @artwork.destroy
        redirect_to artwork_url(@artwork)
    end

    private
    def artwork_params
        params.require(:artwork).permit(:title, :image_url, :artist_id)
    end
end