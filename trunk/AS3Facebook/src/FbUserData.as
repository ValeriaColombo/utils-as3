package
{
	public class FbUserData
	{
		// ====================================================================
		private var token : String;
		private var id : String;
		private var name : String;
		private var last_name : String;
		private var mail : String;
		private var gender : String;
		// ====================================================================
		
		// --------------------------------------------------------------------
		public function FbUserData(_token : String, _id : String, _name : String, _last_name : String, _mail : String, _gender : String)
		{
			token = _token;
			id = _id;
			name = _name;
			last_name = _last_name;
			mail = (_mail != null) ? _mail : "";
			gender = _gender;
		}
		
		public function get Token() : String { return token; }
		public function get Id() : String { return id; }
		public function get Name() : String { return name; }
		public function get LastName() : String { return last_name; }
		public function get Mail() : String { return mail; }
		public function get Gender() : String { return gender; }
	}
}