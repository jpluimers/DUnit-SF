unit ParticleFrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ParticleUnit, GLPanel, OpenGL, ExtCtrls, StdCtrls;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    GLPanel1: TGLPanel;
    btnAddRandom: TButton;
    btnStep: TButton;
    procedure GLPanel1GLDraw(Sender: TObject);
    procedure GLPanel1GLInit(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnAddRandomClick(Sender: TObject);
    procedure GLPanel1Resize(Sender: TObject);
  private
    FPSystem: TParticleSystem3D;

    procedure DrawSphere(X, Y, Z, Radius: currency);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.btnAddRandomClick(Sender: TObject);
begin
  FPSystem.AddRandomParticle;
  GLPanel1.GLReDraw;
end;

procedure TForm1.DrawSphere(X, Y, Z, Radius: currency);
var
  AQuad: PGLUQuadric;
begin
  AQuad := gluNewQuadric;
  glPushMatrix;
  glTranslatef(X, Y, Z);
  gluSphere(AQuad, Radius, 16, 16);
  glPopMatrix;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  if not InitOpenGL then
    raise Exception.Create('Could not load OpenGL dlls.');
  FPSystem := TParticleSystem3D.Create;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  FPSystem.Free;
  CloseOpenGL;
end;

procedure TForm1.GLPanel1GLDraw(Sender: TObject);
var
  i: integer;
  AParticle: TParticle3D;
begin
  //
  // Clear the color and depth buffers.
  //
  glClearColor(0.0, 0.0, 1.0, 1.0);
  glClear(GL_COLOR_BUFFER_BIT or GL_DEPTH_BUFFER_BIT);
  glColor3d(0.0, 1.0, 0.0);

  //
  // Define the modelview transformation.
  //
  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity;
  glTranslatef(-5.0, -5.0, -32.0);
  glRotatef(0.0, 1.0, 0.0, 0.0);
  glRotatef(0.0, 0.0, 1.0, 0.0);

  glPushMatrix;
  for i := 0 to FPSystem.ParticleCount - 1 do
  begin
    AParticle := FPSystem.Particles[i];
    DrawSphere(AParticle.X, AParticle.Y, AParticle.Z, 0.5);
  end;
  glPopMatrix;
  glFlush;

end;

procedure TForm1.GLPanel1GLInit(Sender: TObject);
var
  glfLightAmbient : TGLfloat;
  glfLightDiffuse : TGLfloat;
  glfLightSpecular: TGLfloat;
  Buffer: string;
begin
  //
  // Enable depth testing and backface culling.
  //
  glEnable(GL_DEPTH_TEST);
  glEnable(GL_CULL_FACE);
  //Timer1.Interval :=  TrackBar1.Position * 10;

  //
  // Add a light to the scene.
  //
  glfLightAmbient := 1.0;
  glfLightDiffuse := 0.7;
  glfLightSpecular:= 0.0;

  glLightModelfv(GL_LIGHT_MODEL_AMBIENT, glfLightAmbient);
  //  glLightfv(GL_LIGHT0, GL_AMBIENT, glfLightAmbient);
//  glLightfv(GL_LIGHT0, GL_DIFFUSE, glfLightDiffuse);
//  glLightfv(GL_LIGHT0, GL_SPECULAR,glfLightSpecular);
  glEnable(GL_LIGHTING);
  glEnable(GL_LIGHT0);

  // Enable color tracking
  //glEnable(GL_COLOR_MATERIAL);

  // Set Material properties to follow glColor values
  //glColorMaterial(GL_FRONT, GL_AMBIENT_AND_DIFFUSE);

  Buffer:=StrPas(PChar(glGetString(GL_EXTENSIONS)));
  if Pos('GL_EXT_bgra',Buffer) > 0 then
     GL_EXT_bgra:=True
  else
     GL_EXT_bgra:=False;
end;

procedure TForm1.GLPanel1Resize(Sender: TObject);
var
  gldAspect : TGLdouble;
begin
   // Redefine the viewing volume and viewport when the window size changes.
  gldAspect := GLPanel1.Width / GLPanel1.Height;

  glMatrixMode(GL_PROJECTION);
  glLoadIdentity;
  gluPerspective(30.0,           // Field-of-view angle
                 gldAspect,      // Aspect ratio of viewing volume
                 1.0,            // Distance to near clipping plane
                 100.0);          // Distance to far clipping plane
  glViewport(0, 0, GLPanel1.Width, GLPanel1.Height);
  InvalidateRect(Handle, nil, False);
end;

end.
