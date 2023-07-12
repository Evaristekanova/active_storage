module Paginable
    def current_page
        (params[:page] || 1).to_i
    end

    def per_page
        (params[:per_page] || 2).to_i
    end

    def paginate(collection)
        total_records = collection.count
        total_pages = (total_records.to_f / per_page).ceil
  
        if page_out_of_bounds?(total_pages)
            page_number = total_pages
        else
            page_number = current_page
        end
  
        offset = (page_number - 1) * per_page
        paginated_collection = collection.offset(offset).limit(per_page)
  
        paginated_collection
    end

    def page_out_of_bounds?(total_pages)
        current_page > total_pages
    end

end