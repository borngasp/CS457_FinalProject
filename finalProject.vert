#version 330 compatibility

uniform float uK, uP;
uniform bool uFreeze;
uniform float uWind;

out vec3	vNs;
out vec3	vEs;
out vec3	vMC;

const float PI = 3.14159265;
const float Y0 = 1.;
uniform float Timer;

float distance (float  x, float y){
    return sqrt(x*x + y*y);
}

void
main( )
{    
	float YO = 1.;
    float freeze;
	vMC = gl_Vertex.xyz;
    vec4 newVertex = gl_Vertex;
    newVertex.y = gl_Vertex.y - 200;

    float acceleration = (uWind * 4. * Timer * Timer);
    float wind = uWind;

    if(!uFreeze){
        if((gl_ModelViewMatrix * newVertex).y > 2.0 && (gl_ModelViewMatrix * newVertex).y < 1.0 ){
            newVertex.y -= 1000 * Timer;
        }
        else{
            newVertex.y -= 1500 * Timer;
        }

        freeze = Timer;
        newVertex.x -= acceleration;

        if(gl_MultiTexCoord0.s < .5 && wind > 0){
            newVertex.x = newVertex.x + (acceleration * .02);
            newVertex.y = newVertex.y + (acceleration * .03);
        }
        else if(gl_MultiTexCoord0.s > .5 && wind < 0){
            newVertex.x = newVertex.x - (acceleration * .02);
            newVertex.y = newVertex.y + (acceleration * .03);
        }

    }
    else{
        newVertex.y -= (1000);
        newVertex.x = newVertex.x;
    }


    vec4 ECposition = gl_ModelViewMatrix * newVertex;

    float dzdx = uK * (YO-newVertex.y) * (2.*3.14/uP) * cos( 2.*3.14*newVertex.x/uP );
    vec3 xtangent = vec3( 1., 0., dzdx );

    float dzdy = -uK * sin( 2.*3.14*newVertex.x/uP );
    vec3 ytangent = vec3( 0., 1., dzdy );

    vNs = normalize(  cross( xtangent, ytangent )  );
    vEs = ECposition.xyz - vec3( 0., 0., 0. ) ; 
    
   		// vector from the eye position to the point

    gl_Position = gl_ModelViewProjectionMatrix * newVertex;
}