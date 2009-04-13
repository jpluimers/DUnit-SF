program Particle;

uses
  Forms,
  ParticleFrm in 'ParticleFrm.pas' {Form1},
  ParticleUnit in 'ParticleUnit.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
