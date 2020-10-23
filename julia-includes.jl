function table_to_latex_string(df::DataFrame, caption::String, label::String)::LaTeXString
  colnames = "\\textsc{" .* String.(propertynames(df)) .* "}"
  col_fmt = "r" * ("c"^(size(colnames,1)-1)) * ""
  str = """
  \\begin{table}[h]
  \\centering
  \\caption{$caption}
  \\label{$label}
  \\begin{tabular}{$col_fmt}
    \\toprule
    $(join(colnames, " & ")) \\\\
    \\midrule
  """

  for (idx, row) in enumerate(eachrow(df))
    s = join(values(row), " & ") * (idx != size(df, 1) ? "\\\\" : "\\\\\n\\toprule")
    str = str * s
  end

  str = str * "\n\\end{tabular}\n\\end{table}"
  return LaTeXString(str)
end


function mean_std_table(df::DataFrame; digits=3)::DataFrame
  col_names = String.(propertynames(df))
  names = unique(getindex.(split.(col_names, " "), 1))

  newdf = Dict()
  for colname in names
    colname * " Mean" ∉ col_names && continue  # cannot combine col
    mean_value = df[!, colname * " Mean"]
    std_value  = df[!, colname * " Std"]

    final_col_name = colname * " (STD)"
    newdf[final_col_name] = []
    for (m, s) in zip(mean_value, std_value)
      value_str = "$(round(m, digits=digits)) ($(round(s, digits=digits)))"
      push!(newdf[final_col_name], value_str)
    end
  end
  return DataFrame(newdf)
end

function display_table(df::DataFrame, caption::String, label::String; digits=3)
  # first clean the column names up
  names = begin
    names = propertynames(df)
    names = String.(names)
    names = replace.(names, "_" => " ")
    names = titlecase.(names)
    names = Symbol.(names)
  end
  clean_df = rename(df, names)

  if any(occursin.("Mean", String.(names)))
    m_df = mean_std_table(clean_df)
    clean_df = merge!(clean_df[!, [:Name]], m_df)
  end

  # s = latexify(clean_df; env = :table)
  # s = "\\begin{table}[t!]\n\\caption{$caption}\n\\label{$label}\n" * s * "\n\\end{table}"
  return table_to_latex_string(clean_df, caption, label)
end
