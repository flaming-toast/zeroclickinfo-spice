package DDG::Spice::Zipcode;
# ABSTRACT: return the location and approximate area of a postal code.

use DDG::Spice;
use URI::Escape;

triggers query_lc => qr/^(zip\s*(code)?|post(al)?\s*(code)?)?\s*([a-z0-9]{3}\s?[a-z0-9]{3}|[a-z0-9]+|[0-9\-]+)\s*(\([a-z]{2}\)|[a-z\s]+)?(zip\s*(code)?|post(al)?\s*(code)?)?$/;

spice from => '([A-Z0-9\-]+)(?:/([A-Z]+)?)?';

spice to => '"http://where.yahooapis.com/v1/places${dollar}and(.q($1,$2),.type(11));count=0?appid={{ENV{DDG_SPICE_ZIPCODE_APIKEY}}}&format=json&callback={{callback}}"';

handle query_lc => sub {
	s/\s*\b(zip\s*(code)?|post(al)?\s*(code)?)\b\s*//i;

	my $code;
	
	if (m/([a-z0-9]{3}\s[a-z0-9]{3}|[a-z0-9\-]+)/){
		$code = $1;

		s/$1//;
		$code =~ s/\s//g;

		if (m/\s*\(([a-z]{2})\)\s*/) {
			return uri_escape(uc($code)), $1;
		} elsif (m/\s*([a-z\s]+)\s*/) {
			my %countries = ("afghanistan" => "AF", "albania" => "AL", "algeria" => "DZ", "american samoa" => "AS", "andorra" => "AD", "angola" => "AO", "anguilla" => "AI", "antarctica" => "AQ", "antigua & barbuda" => "AG", "argentina" => "AR", "armenia" => "AM", "aruba" => "AW", "australia" => "AU", "austria" => "AT", "azerbaijan" => "AZ", "bahama" => "BS", "bahrain" => "BH", "bangladesh" => "BD", "barbados" => "BB", "belarus" => "BY", "belgium" => "BE", "belize" => "BZ", "benin" => "BJ", "bermuda" => "BM", "bhutan" => "BT", "bolivia" => "BO", "bosnia and herzegovina" => "BA", "botswana" => "BW", "bouvet island" => "BV", "brazil" => "BR", "british indian ocean territory" => "IO", "british virgin islands" => "VG", "brunei darussalam" => "BN", "bulgaria" => "BG", "burkina faso" => "BF", "burma" => "BU", "burundi" => "BI", "cambodia" => "KH", "cameroon" => "CM", "canada" => "CA", "cape verde" => "CV", "cayman islands" => "KY", "central african republic" => "CF", "chad" => "TD", "chile" => "CL", "china" => "CN", "christmas island" => "CX", "cocos islands" => "CC", "colombia" => "CO", "comoros" => "KM", "congo" => "CG", "cook iislands" => "CK", "costa rica" => "CR", "côte d'ivoire" => "CI", "croatia" => "HR", "cuba" => "CU", "cyprus" => "CY", "czech republic" => "CZ", "czechoslovakia" => "CS", "democratic yemen" => "YD", "denmark" => "DK", "djibouti" => "DJ", "dominica" => "DM", "dominican republic" => "DO", "east timor" => "TP", "ecuador" => "EC", "egypt" => "EG", "el salvador" => "SV", "equatorial guinea" => "GQ", "eritrea" => "ER", "estonia" => "EE", "ethiopia" => "ET", "falkland islands" => "FK", "faroe islands" => "FO", "fiji" => "FJ", "finland" => "FI", "france" => "FR", "france metropolitan" => "FX", "french guiana" => "GF", "french polynesia" => "PF", "french southern territories" => "TF", "gabon" => "GA", "gambia" => "GM", "georgia" => "GE", "german" => "DD", "germany" => "DE", "ghana" => "GH", "gibraltar" => "GI", "great britain" => "GB", "greece" => "GR", "greenland" => "GL", "grenada" => "GD", "guadeloupe" => "GP", "guam" => "GU", "guatemala" => "GT", "guinea" => "GN", "guinea-bissau" => "GW", "guyana" => "GY", "haiti" => "HT", "heard & mcdonald islands" => "HM", "honduras" => "HN", "hong kong" => "HK", "hungary" => "HU", "iceland" => "IS", "india" => "IN", "indonesia" => "ID", "iraq" => "IQ", "ireland" => "IE", "iran" => "IR", "israel" => "IL", "italy" => "IT", "jamaica" => "JM", "japan" => "JP", "jordan" => "JO", "kazakhstan" => "KZ", "kenya" => "KE", "kiribati" => "KI", "korea" => "KP", "korea" => "KR", "kuwait" => "KW", "kyrgyzstan" => "KG", "lao" => "LA", "latvia" => "LV", "lebanon" => "LB", "lesotho" => "LS", "liberia" => "LR", "libyan arab jamahiriya" => "LY", "liechtenstein" => "LI", "lithuania" => "LT", "luxembourg" => "LU", "macau" => "MO", "madagascar" => "MG", "malawi" => "MW", "malaysia" => "MY", "maldives" => "MV", "mali" => "ML", "malta" => "MT", "marshall islands" => "MH", "martinique" => "MQ", "mauritania" => "MR", "mauritius" => "MU", "mayotte" => "YT", "mexico" => "MX", "micronesia" => "FM", "moldova" => "MD", "monaco" => "MC", "mongolia" => "MN", "monserrat" => "MS", "morocco" => "MA", "mozambique" => "MZ", "myanmar" => "MM", "nambia" => "NA", "nauru" => "NR", "nepal" => "NP", "netherlands" => "NL", "netherlands antilles" => "AN", "neutral zone" => "NT", "new caledonia" => "NC", "new zealand" => "NZ", "nicaragua" => "NI", "niger" => "NE", "nigeria" => "NG", "niue" => "NU", "norfolk island" => "NF", "northern mariana islands" => "MP", "norway" => "NO", "oman" => "OM", "pakistan" => "PK", "palau" => "PW", "panama" => "PA", "papua new guinea" => "PG", "paraguay" => "PY", "peru" => "PE", "philippines" => "PH", "pitcairn" => "PN", "poland" => "PL", "portugal" => "PT", "puerto rico" => "PR", "qatar" => "QA", "reunion" => "RE", "romania" => "RO", "russian federation" => "RU", "rwanda" => "RW", "saint lucia" => "LC", "samoa" => "WS", "san marino" => "SM", "sao tome & principe" => "ST", "saudi arabia" => "SA", "senegal" => "SN", "seychelles" => "SC", "sierra leone" => "SL", "singapore" => "SG", "slovakia" => "SK", "slovenia" => "SI", "solomon islands" => "SB", "somalia" => "SO", "south africa" => "ZA", "south georgia and the south sandwich islands" => "GS", "spain" => "ES", "sri lanka" => "LK", "st helena" => "SH", "st kitts and nevis" => "KN", "st pierre & miquelon" => "PM", "st vincent & the grenadines" => "VC", "sudan" => "SD", "suriname" => "SR", "svalbard & jan mayen islands" => "SJ", "swaziland" => "SZ", "sweden" => "SE", "switzerland" => "CH", "syrian arab republic" => "SY", "taiwan, province of china" => "TW", "tajikistan" => "TJ", "tanzania, united republic of" => "TZ", "thailand" => "TH", "togo" => "TG", "tokelau" => "TK", "tonga" => "TO", "trinidad & tobago" => "TT", "tunisia" => "TN", "turkey" => "TR", "turkmenistan" => "TM", "turks & caicos islands" => "TC", "tuvalu" => "TV", "uganda" => "UG", "ukraine" => "UA", "union of soviet socialist republics (no longer exi" => "SU", "united arab emirates" => "AE", "united kingdom" => "GB", "united states minor outlying islands" => "UM", "united states of america" => "US", "united states" => "US", "usa" => "US", "us" => "US", "united states virgin islands" => "VI", "uruguay" => "UY", "uzbekistan" => "UZ", "vanuatu" => "VU", "vatican city state (holy see)" => "VA", "venezuela" => "VE", "viet nam" => "VN", "wallis & futuna islands" => "WF", "western sahara" => "EH", "yemen" => "YE", "yugoslavia" => "YU", "zaire" => "ZR", "zambia" => "ZM", "zimbabwe" => "ZW");
			return uri_escape(uc($code)), $countries{lc ($1)} unless !defined $countries{lc ($1)};
		} else {
			return (uc $code, 'ZZ');
		}
	};

	return;
};

1;