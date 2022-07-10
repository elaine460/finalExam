class Tutor {
  String? tutorId;
  String? tutorEmail;
  String? tutorPhone;
  String? tutorName;
  String? tutorPassword;
  String? tutorDescription;
  String? tutorDatereg;
  String? subjectId;
  String? subjectName;
  String? subjectDescription;
  String? subjectPrice;
  String? subjectSessions;
  String? subjectRating;

  Tutor(
      {this.tutorId,
      this.tutorEmail,
      this.tutorPhone,
      this.tutorName,
      this.tutorPassword,
      this.tutorDescription,
      this.tutorDatereg,
      this.subjectId,
      this.subjectName,
      this.subjectDescription,
      this.subjectPrice,
      this.subjectSessions,
      this.subjectRating});

  Tutor.fromJson(Map<String, dynamic> json) {
    tutorId = json['tutor_id'];
    tutorEmail = json['tutor_email'];
    tutorPhone = json['tutor_phone'];
    tutorName = json['tutor_name'];
    tutorPassword = json['tutor_password'];
    tutorDescription = json['tutor_description'];
    tutorDatereg = json['tutor_datereg'];
    subjectId = json['subject_id'];
    subjectName = json['subject_name'];
    subjectDescription = json['subject_description'];
    subjectPrice = json['subject_price'];
    subjectSessions = json['subject_sessions'];
    subjectRating = json['subject_rating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['tutor_id'] = tutorId;
    data['tutor_email'] = tutorEmail;
    data['tutor_phone'] = tutorPhone;
    data['tutor_name'] = tutorName;
    data['tutor_password'] = tutorPassword;
    data['tutor_description'] = tutorDescription;
    data['tutor_datereg'] = tutorDatereg;
    data['subject_id'] = subjectId;
    data['subject_name'] = subjectName;
    data['subject_description'] = subjectDescription;
    data['subject_price'] = subjectPrice;
    data['subject_sessions'] = subjectSessions;
    data['subject_rating'] = subjectRating;
    return data;
  }
}
