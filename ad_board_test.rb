# frozen_string_literal: true

module AdBoardTest
  class Test

    def initialize(n=10,m=10)
      @ad_board = []
      @board_size_n = n
      @board_size_remaining_n = n
      @board_size_m = n
      @board_size_remaining_m = m
    end

    def show_ad_board
      count = 0
      @ad_board.each do |ad|
        expires_on = ad[:added_at]+ad[:expires_in]
        if expires_on >= Date.today
          count = count + 1
          puts "type: #{ad[:ad_type]} \nsize: #{ad[:ad_size].join(' X ')}\nPrice: #{ad[:ad_price]}\nExpires on: #{expires_on}"
          puts "#################################"
        else

          @ad_board.slice!(@ad_board.index(ad))
          @board_size_remaining_n = @board_size_remaining_n - ad[:ad_size].first
          @board_size_remaining_m = @board_size_remaining_m - ad[:ad_size].last
          # @ad_board.delete(ad)
        end
      end
      puts "Number of ads on board: #{count}"
    end

    def fetch_ad_price(type)
      case type
       when "black_and_white"
         return 2
       when "color_ad"
         return 8
       when "flash_ad"
         return 64
       else
           puts "please pass correct ad name"
       end
    end

    def add_new_ad(type, expires_in, n=1, m=1)
      show_ad_board
      price = fetch_ad_price(type)
      if n>0 && m>0
        if check_board_size(n, m, price)
          @board_size_remaining_n = (@board_size_remaining_n - n)
          @board_size_remaining_m = (@board_size_remaining_m - m)
          new_ad = {ad_type: type, ad_price: price, ad_size: [n,m], added_at: Date.today, expires_in: expires_in}
          @ad_board.push(new_ad)
          puts new_ad
        else
          puts "Ad can't be added"
        end
      else
        puts "Add valid values"
      end
    end

    def check_board_size(n, m, price)

      if @board_size_remaining_n >= n && @board_size_remaining_m >= m
        return true
      elsif @ad_board.blank? && @board_size_remaining_n < n && @board_size_remaining_m < m
        puts "AD Board is not smaller than the AD size"
        return false
      else
        remove_less_revenue_check_ads(n, m, price)
      end
    end

    def remove_less_revenue_check_ads(n, m, price)
      @can_add_ad = false
      if @ad_board.blank?
        false
      else
        sorted_ads = @ad_board.sort_by { |k| k[:ad_price] }
        sorted_ads.each do |ad|
          if ad[:ad_price] < price && !@can_add_ad
            puts "......."
            puts ((@board_size_remaining_n + ad[:ad_size].first) >= n )
            puts ((@board_size_remaining_m + ad[:ad_size].last) >= m)
            if ((@board_size_remaining_n + ad[:ad_size].first) >= n ) && ((@board_size_remaining_m + ad[:ad_size].last) >= m)
              if !@can_add_ad
                @ad_board.slice!(@ad_board.index(ad))
                # @ad_board.delete(ad)
                @board_size_remaining_n = (@board_size_remaining_n + ad[:ad_size].first.to_i)
                @board_size_remaining_m = (@board_size_remaining_m + ad[:ad_size].last.to_i)
                @can_add_ad = true
              end
            end
          end
        end
      end
      return @can_add_ad
    end

  end
end