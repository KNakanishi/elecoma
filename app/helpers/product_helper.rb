# -*- coding: utf-8 -*-
module ProductHelper
  def link_order(order)
     if  params[:order] == order || ( params[:order].blank? && order == "update" )
       return order_name(order)
     else
       link_parameter order_name(order), {:order => order}
     end
  end

  def order_name(order)
    order == "price" ? "価格順" : "新着順"
  end

  def print_date(date)
    date.strftime("%Y年%m月%d日")
  end

  def paginate_item_count(current_page, per_page, total)
    num = current_page * per_page
    if num <= total
      num
    else
      total
    end
  end

  def blank_check(sub_product)
    count = 0
    sub_product.each do |sp|
      count = count + 1 unless sp.large_resource_id.blank?
    end
    if count == 0
      return false
    else
      true
    end
  end

  def stock_mark(count)
    mark = '×'
    rest = count.to_i
    #例 在庫>10:○、0<在庫<=10:△　在庫<=0:×
    #在庫nilの場合、0として
    #△の標準は必ず「0」わけではなく、設定できるよう
    if rest > Product::ZAIKO_MUCH
      mark = '○'
    elsif  rest > Product::ZAIKO_LITTLE
      mark = '△'
    end
    mark
  end

  def content_title_tag(parts)
    parts.reject(&:nil?).join(' - ')
  end

  def already_favorite?
    if @product.set_flag
      @set = ProductSet.find(:first, :conditions => {:product_id => @product.id})
      @pou = ProductOrderUnit.find(:first, :conditions => {:product_set_id => @set.id})
      Favorite.exists?(customer_id: @login_customer.id, product_order_unit_id: @pou.id)
    else
      Favorite.exists?(customer_id: @login_customer.id, product_order_unit_id: @product.first_product_style.product_order_unit.try(:id))
    end
  end
end
