// tipos de datos
type ImageInfo = {
  id : Nat;
  owner : Principal;
  image : Blob;
  title : Text;
};

type UserInfo = {
  owner : Principal;
  email : Text;
};

shared([ImageInfo]) var images = [];
shared([UserInfo]) var users = [];

// almacenar una nueva imagen
public shared({Text}) func storeImage(owner: Principal, image: Blob, title: Text) : async Text {
  let id = images.length + 1;
  let imageInfo = { id = id; owner = owner; image = image; title = title };
  images := images # imageInfo;
  "Imagen guardada correctamente."
};

// obtener información de una imagen
public shared func getImageInfo(id: Nat) : async ImageInfo {
  images[id - 1];
};

//  obtener todas las imágenes
public shared func getAllImages() : async [ImageInfo] {
  images;
};

//  registrar un usuario
public shared({Text}) func registerUser(owner: Principal, email: Text) : async Text {
  let userInfo = { owner = owner; email = email };
  users := users # userInfo;
  "Usuario registrado correctamente."
};

//  obtener información de un usuario
public shared func getUserInfo(owner: Principal) : async UserInfo {
  let user = Array.find(users, func (u) { u.owner == owner });
  switch (user) {
    case (null) { // Usuario no encontrado
      { owner = owner; email = "" };
    };
    case (someUser) {
      someUser;
    };
  };
};

//  enviar un correo electrónico mediante Gmail API
public shared func sendImageByEmail(id: Nat, owner: Principal) : async Text {
  let imageInfo = await getImageInfo(id);
  let userInfo = await getUserInfo(owner);

  // Construir el cuerpo del correo electrónico
  let subject = "tu imagen de  My Image Gallery";
  let body = "Gracias por usar My image Gallery, aqui esta tu iamgen: " # imageInfo.title;

  // enviar el correo electrónico con la imagen adjunta
  let emailResult = await sendEmailViaGmail(userInfo.email, subject, body, imageInfo.image);

  if (emailResult) {
    "Email enviado correctamente.";
  } else {
    "email no enviado.";
  }
};

// Función para enviar un correo electrónico mediante Gmail API
public shared func sendEmailViaGmail(to: Text, subject: Text, body: Text, attachment: Blob) : async Bool {

    // Implementa la lógica real de envío de correo electrónico usando la API de Gmail aquí
 

  Debug.print("Sending email to: " # to);
  Debug.print("Subject: " # subject);
  Debug.print("Body: " # body);
  Debug.print("Attachment Size: " # Prim.toText(attachment.size()));
  
  true; // Supongamos que el envío de correo electrónico fue exitoso
};