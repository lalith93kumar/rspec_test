class Utility

  def initialize()
  end

  def deep_diff(a, b)
    (a.keys | b.keys).each_with_object({}) do |k, diff|
      if a[k] != b[k]
        if a[k].is_a?(Hash) && b[k].is_a?(Hash)
          diff[k] = deep_diff(a[k], b[k])
        else
          diff[k] = [a[k], b[k]]
        end
      end
      diff
    end
  end

  def response_body_to_hash(res)
    if res.content_type!=nil  && res.content_type.include?('application/json')
      return JSON.parse(res.body)
    elsif res.content_type!=nil  && res.content_type.include?('application/xml')
      return Hash.from_xml(res.body)
    else
      return {}
    end
  end

end
